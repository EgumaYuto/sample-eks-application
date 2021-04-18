locals {
  role              = "main-private-subnet"
  vpc_id            = data.terraform_remote_state.vpc.outputs.id
  newbits           = 8
  cidr_block        = var.main_vpc_cidr_block
  public_subnet_ids = data.terraform_remote_state.public_subnet.outputs.ids
}