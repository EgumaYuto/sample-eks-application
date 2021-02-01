resource "aws_ecr_repository" "ecr" {
  name = local.name
}