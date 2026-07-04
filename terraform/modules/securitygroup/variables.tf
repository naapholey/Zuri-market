variable "security_group_name"  {
  type        = string
  description = "Name of the security group"
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}
variable "inbound_port" {
  type        = number
  description = "Port for inbound traffic"
}

variable "ssh_port" {
  type        = number
  description = "Port for SSH access"
}

variable "outbound_port" {
  type        = number
  description = "Port for outbound traffic"
}
 variable "https_port" {
  type        = number
  description = "Port for HTTPS traffic"
 }
 variable "kubernetes_api_port" {
  type        = number
  description = "Port for Kubernetes API server"
 }
 variable "node_port" {
  type        = number
  description = "Port for Kubernetes NodePort service"
 }
 variable "runner_ssh_ip" {
 
}
