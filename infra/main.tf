provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./vpc"
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  name                 = var.name
  cluster_name         = var.cluster_name
}

resource "aws_ecr_repository" "app_repo" {
  name = "devops-app"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.11.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
    }
  }
}