data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/service/sample-api/ecr.tfstate"
    region = var.default_region
  }
}

data "aws_ecr_repository" "repository" {
  name = data.terraform_remote_state.ecr.outputs.name
}