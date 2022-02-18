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
  name   = "allow_http_web"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

/* resource "aws_instance" "web" {
  ami                    = var.ami_linux
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd.x86_64
              sudo systemctl start httpd.service
              sudo systemctl enable httpd.service
              echo "Hello, World Alex" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
} */

module "ec2" {
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
            sudo yum update -y
            sudo yum install -y httpd.x86_64            
            echo "<!DOCTYPE html><html><head><title>Example</title></head><body><p>This is an example of a simple HTML page with one paragraph.</p></body></html>" > /var/www/html/index.html
            sudo systemctl start httpd.service
            sudo systemctl enable httpd.service
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

  azs            = var.vpc_azs
  public_subnets = var.vpc_public_subnets
  tags           = var.vpc_tags
}