terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../../_module/naming"
  role   = local.role
}

resource "aws_vpc" "vpc" {
  cidr_block           = local.cidr_block
  tags                 = module.naming.tags
}