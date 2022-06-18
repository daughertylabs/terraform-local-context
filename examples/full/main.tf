terraform {
  required_version = ">= 1.0.0"
}

module "this" {
  source = "../../"

  enabled         = true
  organization    = "dbs"
  cloud_provider  = "az"
  parent_name     = "dbs-az-root"
  name            = "workloads"
  environment     = "production"
  env_subtype     = "blue"
  project_owners  = ["billing.dept@example.com"]
  project         = "000-INFRASTRUCTURE"
  project_type    = "NONBILL"
  code_owners     = ["ATeamDL@example.com", "SwatDL@example.com"]
  data_owners     = ["ATeamDL@example.com", "SwatDL@example.com"]
  availability    = "always_on"
  deployer        = "manual-test"
  confidentiality = "public"
  data_regs       = ["GDPR"]
  security_review = "2021-07-04"
  privacy_review  = "2021-07-04"
}

output "name_prefix" {
  value = module.this.name_prefix
}

output "namespace_full" {
  value = module.this.namespace_full
}

output "tags" {
  value = module.this.tags
}

output "tags_with_name" {
  value = module.this.tags_with_name
}

output "tags_as_list_of_maps" {
  value = module.this.tags_as_list_of_maps
}

output "env_code" {
  value = module.this.env_code
}

output "region_code_map" {
  value = module.this.region_code_map
}

output "normalized_context" {
  value = module.this.normalized_context
}

output "context" {
  value = module.this.context
}
