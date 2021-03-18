#########
# Public
#########
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.cidr_block, local.newbits, 0 + count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${local.name} public ${var.availability_zones[count.index]}}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public[count.index].id
}

##########
# Private
##########
resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.cidr_block, local.newbits, length(var.availability_zones) + count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${local.name} private ${var.availability_zones[count.index]}"
  }
}

resource "aws_eip" "nat_ip" {
  count = length(var.availability_zones)
  tags = {
    Name = "nat ${element(var.availability_zones, count.index)}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association_a" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}
