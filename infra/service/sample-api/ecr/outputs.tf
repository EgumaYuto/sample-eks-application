output "name" {
  value = local.name
}

output "arn" {
  value = var.primary_env ? aws_ecr_repository.repository[0].arn : data.aws_ecr_repository.repository.arn
}

output "repository_url" {
  value = var.primary_env ? aws_ecr_repository.repository[0].repository_url : data.aws_ecr_repository.repository.repository_url
}

data "aws_ecr_repository" "repository" {
  count = var.primary_env ? 0 : 1
  name  = local.name
}