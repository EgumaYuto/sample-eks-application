module "naming" {
  source = "../../../../_module/naming"
  role   = local.role
}

resource "aws_vpc" "vpc" {
  cidr_block         = local.cidr_block
  enable_dns_support = true
  tags               = module.naming.tags
}

