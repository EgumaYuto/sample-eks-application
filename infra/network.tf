provider "aws" {
  region = "ap-northeast-1"
}


######
# VPC
######
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
}

resource "aws_flow_log" "log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type = "ALL"
  vpc_id       = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = local.name
}

resource "aws_iam_role" "flow_log_role" {
  name = local.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = "example"
  role = aws_iam_role.flow_log_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

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
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "public_1c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "public_1d" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1d"
}

resource "aws_subnet" "private_1a" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private_1c" {
  cidr_block = "10.0.4.0/24"
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "private_1d" {
  cidr_block = "10.0.5.0/24"
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "ap-northeast-1d"
}

###############
# Nat Gateway
###############
resource "aws_eip" "nat_public_1a_ip" {
  tags = {
    Name = "nat public 1a"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_public_1a_ip.id
  subnet_id     = aws_subnet.public_1a.id
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
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association_a" {
  route_table_id = aws_route_table.private_subnet_route_table.id
  subnet_id      = aws_subnet.private_1a.id
}

resource "aws_route_table_association" "private_subnet_route_table_association_c" {
  route_table_id = aws_route_table.private_subnet_route_table.id
  subnet_id      = aws_subnet.private_1c.id
}

resource "aws_route_table_association" "private_subnet_route_table_association_d" {
  route_table_id = aws_route_table.private_subnet_route_table.id
  subnet_id      = aws_subnet.private_1d.id
}