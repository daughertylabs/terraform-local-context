terraform {
  required_version = ">= 1.0.0"
}

module "this" {
  source = "../../"

  name = "minimalcontext"
}

output "name_prefix" {
  value = module.this.name_prefix
}

output "tags" {
  value = module.this.tags
}
