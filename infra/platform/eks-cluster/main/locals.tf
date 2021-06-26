locals {
  role = "main-cluster"
  subnet_ids = data.terraform_remote_state.private_subnet.outputs.ids
}