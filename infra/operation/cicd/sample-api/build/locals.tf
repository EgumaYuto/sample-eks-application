locals {
  role               = "sample-api-build"
  repository_uri     = data.aws_ecr_repository.repository.repository_url
  aws_default_region = var.default_region
}