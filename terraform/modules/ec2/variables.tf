
variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "project_name" {
    default = "zuriapp"
}

variable "environment" {
    default = "dev"
}

variable "instance_profile" {
    default = "zuriapp-instance-profile"
}

variable "iam_role_name" {
    default = "zuriapp-iam-role"
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
}

variable "secret_arn" {
  default = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret-arn"
}

variable "iam_policy" {
  default = "zuriapp-iam-policy"
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of IDs of security groups to associate with the EC2 instance"
  type        = list(string)
}

