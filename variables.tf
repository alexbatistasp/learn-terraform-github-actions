# Input variable definitions

variable "vpc_name" {
  description = "VPC-TERRA"
  type        = string
  default     = "terra-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "ami_linux" {
  description = "Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type"
  type        = string
  default     = "ami-0341aeea105412b57"
}
