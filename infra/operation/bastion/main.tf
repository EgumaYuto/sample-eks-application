terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../_module/naming"
  role   = local.role
}

resource "aws_instance" "bastion" {
  ami                    = local.ami
  instance_type          = local.instance_type
  subnet_id              = local.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  user_data              = local.user_data
  tags                   = module.naming.tags
}

