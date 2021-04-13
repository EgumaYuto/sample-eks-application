locals {
  role             = "sample-api"
  vpc_id           = data.terraform_remote_state.vpc.outputs.id
  subnet_ids       = data.terraform_remote_state.private_subnet.outputs.ids
  target_group_arn = data.terraform_remote_state.elb.outputs.target_group.arn
  listener_arn     = data.terraform_remote_state.elb.outputs.listener.arn
}