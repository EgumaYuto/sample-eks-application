locals {
  role           = "main-vpc"
  cidr_block     = var.main_vpc_cidr_block
  flow_log_group = "/${terraform.workspace}/${local.role}/flow_log/"
}