module "vpc" {
  source = "./modules/vpc"

  vpc_name             = "zuriapp-vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  //private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  environment          = "dev"
}

module "securitygroup" {
  source = "./modules/securitygroup"
  runner_ssh_ip = var.runner_ssh_ip
  vpc_id = module.vpc.vpc_id
  security_group_name = "zuriapp-sg"
  inbound_port = 80
  ssh_port = 22
  outbound_port = 0
  https_port = 443
  //kubernetes_api_port = 6443
  node_port = 30000
}

data "aws_secretsmanager_secret" "store" {
  name = "zuri-k3s-kubeconfig"
}
module "ec2" {
    source = "./modules/ec2"

  subnet_id         = module.vpc.public_subnet_ids[0]
  key_name          =  "lamp-key"
  vpc_security_group_ids = [module.securitygroup.security_group_id]
  environment       = "prod"

  secret_arn       = data.aws_secretsmanager_secret.store.arn
  iam_policy       = "zuriapp-secrets-policy"
  instance_profile = "zuriapp-ec2-profile"
  
}
terraform {
  backend "s3" {
    bucket         = "zuriapp-terraform-state-831e2263" # update this with your unique bucket name
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "zuriapp-terraform-state-locks"
    encrypt        = true
  }
}