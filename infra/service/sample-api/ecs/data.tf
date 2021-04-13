data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/network/main/vpc.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "private_subnet" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/network/main/subnet/private.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "main_cluster" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/ecs-cluster/main.tfstate"
    region = var.default_region
  }
}

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

data "terraform_remote_state" "elb" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/service/sample-api/elb.tfstate"
    region = var.default_region
  }
}