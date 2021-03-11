locals {
  name = "http-api-sample"
  vpc = {
    name = "${local.name}-vpc"
    flow_log = {
      name = "${local.name}-vpc-flow-log"
    }
  }
}