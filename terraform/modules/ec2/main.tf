data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

/*  import {
  to = aws_iam_role.iam_role
  id = zuriapp-iam-role//"arn:aws:iam::870737143368:role/zuriapp-iam-role"
} */
 
resource "aws_iam_role" "iam_role" {
  name = var.iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
/*  import {
  to = aws_iam_policy.iam_policy
  id = "arn:aws:iam::870737143368:policy/zuriapp-secrets-policy"
}  */
resource "aws_iam_policy" "iam_policy" {
  name = var.iam_policy

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secret_arn
      }
    ]
  })
}

#------------ ATTACH POLICY ------------ 

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}


#------------ INSTANCE PROFILE ------------ 

/*  import {
  to = aws_iam_instance_profile.instance_profile
  id = "zuriapp-ec2-profile"
}  */
resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "zuriapp-iam-role-" 
  role = aws_iam_role.iam_role.name
}


resource "aws_instance" "k3s" {
    ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  user_data = file("${path.module}/user-data.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "${var.project_name}-k3s"
    Environment = var.environment
  }
}

resource "aws_eip" "k3s" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_eip_association" "k3s" {
  instance_id   = aws_instance.k3s.id
  allocation_id = aws_eip.k3s.id
}
