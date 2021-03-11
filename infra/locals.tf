locals {
  cidr_block = "10.0.0.0/16"
  name = "http-api-sample"
  vpc = {
    name = "${local.name}-vpc"
    flow_log = {
      name = "${local.name}-vpc-flow-log"
    }
  }
}