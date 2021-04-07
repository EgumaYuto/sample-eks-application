locals {
  role       = "main-private-subnet"
  vpc_id     = data.terraform_remote_state.vpc.outputs.id
  newbits    = 8
  cidr_block = var.main_vpc_cidr_block
}