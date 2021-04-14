resource "aws_security_group" "security_group" {
  name        = "${module.naming.name}-private-vpc-link"
  description = "${module.naming.name} private vpc link"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name        = "com.amazonaws.${var.default_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  vpc_id              = local.vpc_id
  subnet_ids          = aws_subnet.subnet.*.id
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  service_name        = "com.amazonaws.${var.default_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  vpc_id              = local.vpc_id
  subnet_ids          = aws_subnet.subnet.*.id
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "secretsmanager" {
  service_name        = "com.amazonaws.${var.default_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  vpc_id              = local.vpc_id
  subnet_ids          = aws_subnet.subnet.*.id
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  service_name        = "com.amazonaws.${var.default_region}.ssm"
  vpc_endpoint_type   = "Interface"
  vpc_id              = local.vpc_id
  subnet_ids          = aws_subnet.subnet.*.id
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  service_name        = "com.amazonaws.${var.default_region}.logs"
  vpc_endpoint_type   = "Interface"
  vpc_id              = local.vpc_id
  subnet_ids          = aws_subnet.subnet.*.id
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}