data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/network/main/vpc.tfstate"
    region = var.default_region
  }
}