terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../../_module/naming"
  role   = local.role
}

module "app_naming" {
  source = "../../../../_module/naming"
  role   = local.app_name
}

resource "aws_codedeploy_app" "app" {
  name             = module.app_naming.name
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "blue_green" {
  app_name               = aws_codedeploy_app.app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = module.naming.name
  service_role_arn       = aws_iam_role.role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = local.cluster_name
    service_name = local.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [local.listener_arn]
      }

      target_group {
        name = local.green_group_name
      }

      target_group {
        name = local.blue_group_name
      }
    }
  }
}