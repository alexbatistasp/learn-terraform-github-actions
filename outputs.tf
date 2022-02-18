# Output variable definitions
output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "web-address" {
  value = "${module.ec2_instances.public_dns}:8080"
}