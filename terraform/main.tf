terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_ecs_cluster" "tabwriter_cluster" {
  name               = "tabwriter-cluster"
  capacity_providers = ["FARGATE"]
  tags = {
    application = "TabWriter"
  }
}

resource "aws_cloudwatch_log_group" "tabwriter_logs" {
  name = "tabwriter-logs"
  tags = {
    application = "TabWriter"
  }
}

resource "aws_ecs_task_definition" "tabwriter_task" {
  family                   = "tabwriter-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = templatefile("templates/task_definition.json.tpl", {})
  execution_role_arn       = aws_iam_role.tabwriter_task_execution_role.arn
  tags = {
    application = "TabWriter"
  }
}