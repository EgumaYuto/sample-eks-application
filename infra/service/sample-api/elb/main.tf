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

resource "aws_alb" "alb" {
  name            = module.naming.name
  security_groups = [aws_security_group.security_group.id]
  subnets         = local.subnet_ids
  internal        = true
}

resource "aws_alb_target_group" "green_group" {
  name        = "${module.naming.name}-green"
  vpc_id      = local.vpc_id
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"
}

resource "aws_alb_target_group" "blue_group" {
  name        = "${module.naming.name}-blue"
  vpc_id      = local.vpc_id
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.green_group.arn
    type             = "forward"
  }
}