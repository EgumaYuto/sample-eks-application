variable "state_bucket" {
  type        = string
  description = "terraform remote state を管理するバケットの名前"
}

variable "default_region" {
  type        = string
  description = "デフォルトのリージョン"
}

variable "main_vpc_cidr_block" {
  type        = string
  description = "cidr block"
}