resource "aws_vpc_endpoint" "s3" {
  service_name        = "com.amazonaws.${var.default_region}.s3"
  vpc_endpoint_type   = "Gateway"
  vpc_id              = aws_vpc.vpc.id
}