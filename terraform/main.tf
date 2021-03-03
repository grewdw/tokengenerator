terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
  }

  backend "remote" {
    organization = "davidgrew"

    workspaces {
      prefix = "tokengenerator-"
    }
  }

  required_version = ">= 0.13.0"
}

provider "aws" {
  region = "eu-west-2"
}

locals {
  application = "TabWriter"
  name        = "tabwriter-tokengenerator-${var.environment}"
}

data "aws_ami" "amazon_ami" {
  most_recent = true
  name_regex  = "amzn2-ami-hvm-2.0.20210219.0-x86_64-gp2"
  owners      = ["amazon"]
}

resource "aws_instance" "tabwriter_instance" {
  ami                    = data.aws_ami.amazon_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tabwriter_security_group.id]
  user_data = templatefile("./templates/user_data.sh.tpl", {
    AT                = aws_ssm_parameter.auth_token.name
    PK                = aws_ssm_parameter.apple_music_private_key.name
    KI                = aws_ssm_parameter.apple_music_key_identifier.name
    TI                = aws_ssm_parameter.apple_music_team_id.name
    TAG               = var.tag
    DOMAIN            = var.domain,
    ENABLE_TLS        = var.enable_tls ? "--enable-tls" : ""
    CLOUDWATCH_CONFIG = "s3://${aws_s3_bucket.tabwriter_s3_bucket.id}/${aws_s3_bucket_object.cloudwatch_config.id}"
  })
  key_name             = var.host
  iam_instance_profile = aws_iam_instance_profile.tabwriter_profile.name

  tags = {
    Name        = "${local.name}-instance"
    Application = local.application
  }
}

data "aws_eip" "elastic_ip" {
  tags = {
    Domain = var.domain
  }
}

resource "aws_eip_association" "eip_association" {
  instance_id   = aws_instance.tabwriter_instance.id
  allocation_id = data.aws_eip.elastic_ip.id
}

output "tabwriter_public_ip" {
  value       = aws_instance.tabwriter_instance.public_ip
  description = "Public IP for TabWriter instance:"
}
