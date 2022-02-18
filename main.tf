terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    hostname     = "app.terraform.io"
    organization = "ALX-Terraform-Labs"

    workspaces {
      name = "demo-giithub-actions"
    }
    token = "F2X0npxy6cOcXA.atlasv1.ID1cuTESoCJdyUPYWDymdFwxPt17RtynPIY4Ok9lgw4vgx15lAWoGbEIf4sR3hTFhIc"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "web-sg" {
  name   = "allow_tcp_web"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* resource "aws_instance" "web" {
  ami                    = var.ami_linux
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World Alex" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
} */

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "my-ec2-web"
  instance_count = 1

  ami                    = var.ami_linux
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id              = module.vpc.public_subnets[0]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World Alex" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}