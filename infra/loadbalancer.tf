resource "aws_alb" "alb" {
  name            = local.name
  security_groups = [aws_security_group.ecs_sg.id]
  subnets = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id,
  ]
  internal = true
}

resource "aws_alb_target_group" "target_group" {
  name        = local.name
  vpc_id      = aws_vpc.vpc.id
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}