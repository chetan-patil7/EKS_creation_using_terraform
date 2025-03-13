terraform {

  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = "~> 5.0"
	}
  }
  backend "s3" {
	bucket = "s3-demo-eks-1234567890"
	key    = "terraform.tfstate"
	region = "us-east-1"
	dynamodb_table = "tf-eks-table"
	encrypt = true

  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr
  availability_zones = var.availability_zones
  private-subnet-cidrs = var.private_subnet_cidrs
  public-subnet-cidrs = var.public_subnet_cidrs
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  node_groups = var.node_groups

}
