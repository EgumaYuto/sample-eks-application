locals {
  name          = var.state_bucket
  force_destroy = false
  versioning    = true
}