locals {
  count = var.primary_env ? 1 : 0
  name  = "sample-api"
}