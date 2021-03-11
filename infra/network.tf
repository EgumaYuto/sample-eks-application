###################
# Internet Gateway
###################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

#########
# Subnet
#########
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "demo_public_1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "demo_public_1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "demo_public_1d"
  }
}

resource "aws_subnet" "private_1a" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "demo_private_1a"
  }
}

resource "aws_subnet" "private_1c" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "demo_private_1c"
  }
}

resource "aws_subnet" "private_1d" {
  cidr_block        = "10.0.5.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1d"

  tags = {
    Name = "demo_private_1d"
  }
}

###############
# Nat Gateway
###############
resource "aws_eip" "nat_public_1a_ip" {
  tags = {
    Name = "nat public 1a"
  }
}

resource "aws_nat_gateway" "ngw_a" {
  allocation_id = aws_eip.nat_public_1a_ip.id
  subnet_id     = aws_subnet.public_1a.id
}

resource "aws_eip" "nat_public_1c_ip" {
  tags = {
    Name = "nat public 1c"
  }
}

resource "aws_nat_gateway" "ngw_c" {
  allocation_id = aws_eip.nat_public_1c_ip.id
  subnet_id     = aws_subnet.public_1c.id
}

resource "aws_eip" "nat_public_1d_ip" {
  tags = {
    Name = "nat public 1d"
  }
}

resource "aws_nat_gateway" "ngw_d" {
  allocation_id = aws_eip.nat_public_1d_ip.id
  subnet_id     = aws_subnet.public_1d.id
}

################
# Public routes
################
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_route_table_association_a" {
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public_1a.id
}

resource "aws_route_table_association" "public_subnet_route_table_association_c" {
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public_1c.id
}

resource "aws_route_table_association" "public_subnet_route_table_association_d" {
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public_1d.id
}

#################
# Private routes
#################
resource "aws_route_table" "private_subnet_route_table_1a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw_a.id
  }
}

resource "aws_route_table" "private_subnet_route_table_1c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw_c.id
  }
}

resource "aws_route_table" "private_subnet_route_table_1d" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw_d.id
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association_a" {
  route_table_id = aws_route_table.private_subnet_route_table_1a.id
  subnet_id      = aws_subnet.private_1a.id
}

resource "aws_route_table_association" "private_subnet_route_table_association_c" {
  route_table_id = aws_route_table.private_subnet_route_table_1c.id
  subnet_id      = aws_subnet.private_1c.id
}

resource "aws_route_table_association" "private_subnet_route_table_association_d" {
  route_table_id = aws_route_table.private_subnet_route_table_1d.id
  subnet_id      = aws_subnet.private_1d.id
}