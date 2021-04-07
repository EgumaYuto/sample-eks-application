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
  cidr_block        = cidrsubnet(local.cidr_block, local.newbits, length(var.default_availability_zones) + count.index)
  availability_zone = element(var.default_availability_zones, count.index)

  tags = module.naming.tags
}

resource "aws_eip" "nat_ip" {
  count = length(var.default_availability_zones)
  tags = {
    Name = "nat ${element(var.default_availability_zones, count.index)}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.default_availability_zones)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.subnet[count.index].id
}

resource "aws_route_table" "private" {
  count  = length(var.default_availability_zones)
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association_a" {
  count          = length(var.default_availability_zones)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.subnet[count.index].id
}