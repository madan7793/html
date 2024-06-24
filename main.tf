provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source              = "./terraform/modules/vpc"
  cidr_block          = "10.0.0.0/16"
  name                = "example-vpc"
  subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source            = "./terraform/modules/eks"
  cluster_name      = "example-cluster"
  cluster_role_arn  = aws_iam_role.cluster.arn
  node_role_arn     = aws_iam_role.node.arn
  subnet_ids        = module.vpc.subnet_ids
  node_group_name   = "example-node-group"
  instance_types    = ["t3.medium"]
  desired_size      = 2
  max_size          = 3
  min_size          = 1
}




