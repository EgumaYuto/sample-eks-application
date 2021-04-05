terraform {
  backend "s3" {
    bucket = "sample-ecs-application-tfstate"
    key    = "infra/platform/network/main/vpc"
    region = "ap-northeast-1"
  }
}