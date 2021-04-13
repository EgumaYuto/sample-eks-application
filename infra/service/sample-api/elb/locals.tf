locals {
  role       = "sample-api"
  vpc_id     = data.terraform_remote_state.vpc.outputs.id
  subnet_ids = data.terraform_remote_state.private_subnet.outputs.ids
}