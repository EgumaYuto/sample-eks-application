output "service" {
  value = {
    name = aws_ecs_service.service.name
  }
}