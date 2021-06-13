terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

data "aws_ecr_repository" "repository" {
  name  = local.name
}