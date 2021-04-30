data "terraform_remote_state" "main_cluster" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/platform/ecs-cluster/main.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/service/sample-api/ecs.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "elb" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "env:/${terraform.workspace}/state/service/sample-api/elb.tfstate"
    region = var.default_region
  }
}