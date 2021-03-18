locals {
  cidr_block = "10.0.0.0/16"
  newbits    = 8
  name       = "http-api-sample"
  vpc = {
    name = "${local.name}-vpc"
    flow_log = {
      name = "${local.name}-vpc-flow-log"
    }
  }
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}