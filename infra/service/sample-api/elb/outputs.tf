output "target_group" {
  value = {
    green = {
      arn  = aws_alb_target_group.green_group.arn
      name = aws_alb_target_group.green_group.name
    }
    blue = {
      arn  = aws_alb_target_group.blue_group.arn
      name = aws_alb_target_group.blue_group.name
    }
  }
}

output "listener" {
  value = {
    arn = aws_alb_listener.alb.arn
  }
}