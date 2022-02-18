# Output variable definitions
output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "ec2-dns" {
  description = "Public DNS addresses of EC2 instances"
  value       = module.ec2.public_dns
}