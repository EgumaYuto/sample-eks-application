locals {
  role     = "sample-api-deploy"
  app_name = "sample-api"

  cluster_name     = data.terraform_remote_state.main_cluster.outputs.name
  service_name     = data.terraform_remote_state.ecs.outputs.service.name
  green_group_name = data.terraform_remote_state.elb.outputs.target_group.green.name
  blue_group_name  = data.terraform_remote_state.elb.outputs.target_group.blue.name
  listener_arn     = data.terraform_remote_state.elb.outputs.listener.arn
}