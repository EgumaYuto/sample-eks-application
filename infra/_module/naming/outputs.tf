output "name" {
  value = local.name
}

output "tags" {
  value = {
    Name    = local.name
    Env     = terraform.workspace
    Managed = "Terraform"
  }
}

