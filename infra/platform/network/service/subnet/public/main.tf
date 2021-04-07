terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../../../_module/naming"
  role   = local.role
}

resource "aws_subnet" "subnet" {
  count = length(var.default_availability_zones)

  vpc_id            = local.vpc_id
  cidr_block        = cidrsubnet(local.cidr_block, local.newbits, 0 + count.index)
  availability_zone = element(var.default_availability_zones, count.index)

  tags = module.naming.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id
}

resource "aws_route_table" "route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}