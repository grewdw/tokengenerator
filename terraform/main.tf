terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
  }

  backend "s3" {
    bucket = "dg-development-bucket-general"
    key    = "terraform/tabwriter.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}

locals {
  application = "TabWriter"
  environment = terraform.workspace == "prod" ? "prod" : "dev"
  name        = "tabwriter-tokengenerator-${local.environment}"
}

data "aws_ami" "amazon_ami" {
  most_recent = true
  name_regex  = "amzn2-ami-hvm-2.0.20210126.0-x86_64-gp2"
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
    tag               = var.tag
    domain            = var.domain,
    enable_encryption = var.enable_encryption ? "--enable-encryption" : ""
  })
  key_name             = var.host
  iam_instance_profile = aws_iam_instance_profile.tabwriter_profile.name

  tags = {
    Name        = "${local.name}-instance"
    Application = local.application
  }
}

output "tabwriter_public_ip" {
  value       = aws_instance.tabwriter_instance.public_ip
  description = "Public IP for TabWriter instance:"
}
