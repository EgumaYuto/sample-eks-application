terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

resource "aws_ecr_repository" "repository" {
  count = local.count
  name  = local.name
}