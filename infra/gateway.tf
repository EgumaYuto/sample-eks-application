resource "aws_apigatewayv2_api" "demo" {
  name = local.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "demo" {
  api_id                 = aws_apigatewayv2_api.demo.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "GET"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
  integration_uri        = aws_alb_listener.alb.arn
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "demo" {
  api_id = aws_apigatewayv2_api.demo.id
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
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name = "demo"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id, aws_subnet.private_1d.id]
  security_group_ids = [aws_security_group.ecs_sg.id]
}

//resource "aws_api_gateway_rest_api" "demo" {
//  name = local.name
//
//  body = jsonencode({
//    openapi = "3.0.1"
//    info = {
//      title = "example"
//      version = "1.0"
//    }
//    paths = {
//      "/" = {
//        get = {
//          x-amazon-apigateway-integration = {
//            httpMethod           = "GET"
//            type                 = "HTTP_PROXY"
//            connectionType       = "VPC_LINK"
//            connectionId         = aws_apigatewayv2_vpc_link.vpc_link.id
//            uri                  = aws_alb.alb.arn
//            payloadFormatVersion = "1.0"
//          }
//        }
//      }
//    }
//  })
//
//  endpoint_configuration {
//    types = ["REGIONAL"]
//  }
//}
//
//resource "aws_api_gateway_deployment" "deployment" {
//  rest_api_id = aws_api_gateway_rest_api.demo.id
//
//  triggers = {
//    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.demo.body))
//  }
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//resource "aws_api_gateway_stage" "v1" {
//  deployment_id = aws_api_gateway_deployment.deployment.id
//  rest_api_id   = aws_api_gateway_rest_api.demo.id
//  stage_name    = "v1"
//}


