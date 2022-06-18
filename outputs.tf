output "name_prefix" {
  description = "Disambiguated ID or name prefix for resources in the context."
  value       = local.enabled ? local.id : ""
}

output "namespace_full" {
  description = "Fully-qualified namespace for resources in the context."
  value       = local.enabled ? local.ns_full : ""
}

output "tags" {
  description = "Normalized tag map."
  value       = local.enabled ? local.tags : {}
}

output "tags_with_name" {
  description = "normalized tag map including Name tag."
  value       = local.enabled ? local.tags_all : {}
}

output "tags_as_list_of_maps" {
  description = "Additional tags as a list of maps, which can be used in several AWS resources"
  value       = local.tags_as_list_of_maps
}

output "env_code" {
  description = "Short code for the deployment environment."
  value       = local.enabled ? local.stage : ""
}

output "region_code_map" {
  description = "Mappings of cloud provider region ids to standard short codes."
  value       = local.enabled ? local.regions_map : {}
}

output "normalized_context" {
  description = "Normalized context of this module"
  value       = local.output_context
}

output "context" {
  description = "Merged but otherwise unmodified input to this module, to be used as context input to other modules."
  value       = local.input
}
