terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../_module/naming"
  role   = local.role
}

resource "aws_apigatewayv2_api" "demo" {
  name          = module.naming.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "demo" {
  api_id                 = aws_apigatewayv2_api.demo.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "GET"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
  integration_uri        = local.listener_arn
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "demo" {
  api_id    = aws_apigatewayv2_api.demo.id
  route_key = "GET /sample"

  target = "integrations/${aws_apigatewayv2_integration.demo.id}"
}

resource "aws_apigatewayv2_deployment" "demo" {
  api_id = aws_apigatewayv2_api.demo.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id        = aws_apigatewayv2_api.demo.id
  name          = "$default"
  auto_deploy   = true
  deployment_id = aws_apigatewayv2_deployment.demo.id

  lifecycle {
    ignore_changes = [deployment_id]
  }
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "demo"
  subnet_ids         = local.subnet_ids
  security_group_ids = [aws_security_group.security_group.id]
}