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

module "child" {
  source = "../../"

  context        = module.this.normalized_context
  name           = "devteams"
  project_owners = ["hannibal.smith@example.com"]
}

module "grandchild" {
  source = "../../"

  context         = module.child.context
  attributes      = ["redteam"]
  security_review = "2021-08-04"
}

output "parent_name_prefix" {
  value = module.this.name_prefix
}

output "parent_tags" {
  value = module.this.tags
}

output "child_name_prefix" {
  value = module.child.name_prefix
}

output "child_tags" {
  value = module.child.tags
}

output "grandchild_name_prefix" {
  value = module.grandchild.name_prefix
}

output "grandchild_tags" {
  value = module.grandchild.tags
}
