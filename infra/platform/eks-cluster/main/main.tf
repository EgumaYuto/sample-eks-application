terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../_module/naming"
  role   = local.role
}

resource "aws_eks_cluster" "cluster" {
  name     = module.naming.name
  role_arn = aws_iam_role.role.arn
  vpc_config {
    subnet_ids = local.subnet_ids
  }
}