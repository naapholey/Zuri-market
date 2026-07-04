output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}
output "instance_id" {
  value = module.ec2.instance_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}
/* 
output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
} */