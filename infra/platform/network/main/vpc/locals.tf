locals {
  role           = "main-vpc"
  cidr_block     = "10.0.0.0/16"
  flow_log_group = "/${terraform.workspace}/${local.role}/flow_log/"
}