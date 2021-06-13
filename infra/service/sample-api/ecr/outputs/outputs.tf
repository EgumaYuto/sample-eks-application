output "name" {
  value = local.name
}

output "arn" {
  value = data.aws_ecr_repository.repository.arn
}

output "repository_url" {
  value = data.aws_ecr_repository.repository.repository_url
}