data "terraform_remote_state" "private_subnet" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/network/main/subnet/private.tfstate"
    region = var.default_region
  }
}