resource "aws_security_group" "this" {
  name        = var.security_group_name # Name of the security group
  description = "Security group for example application" # Description of the security group
  vpc_id      = var.vpc_id # ID of the VPC where the security group will be created
  // Inbound rules
  ingress {
    from_port   = var.inbound_port     # Port range for the rule
    to_port     = var.inbound_port     # Port range for the rule
    protocol    = "tcp"                  # Protocol (tcp, udp, icmp)
    cidr_blocks = ["0.0.0.0/0"]          # Allowed IP address range (0.0.0.0/0 allows all)
  }

  ingress {
    from_port   = var.ssh_port         # Port range for the rule
    to_port     = var.ssh_port         # Port range for the rule
    protocol    = "tcp"                  # Protocol
    # Appends /32 to lock it down to a single IP address
    cidr_blocks = ["0.0.0.0/0"] 
  }

ingress {
    from_port   = var.https_port                   # Port range for the rule
    to_port     = var.https_port                   # Port range for the rule
    protocol    = "tcp"                  # Protocol
    cidr_blocks = ["0.0.0.0/0"] 
}

ingress {
  from_port = var.kubernetes_api_port
  to_port = var.kubernetes_api_port
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = var.node_port
  to_port     = var.node_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
}
  // Outbound rules
  egress {
    from_port   = var.outbound_port     # Port range for all outbound traffic
    to_port     = var.outbound_port     # Port range for all outbound traffic
    protocol    = "-1"                    # All protocols
    cidr_blocks = ["0.0.0.0/0"]           # Allowed IP address range for outbound traffic
  }
}