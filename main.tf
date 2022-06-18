locals {
  defaults = {
    regex_replace_chars = "/[^-a-zA-Z0-9]/"
    id_delimiter        = "-"
    replacement         = ""
    id_length_limit     = 63
    id_hash_length      = 5
    tag_delimiter       = ";"
    tag_length_limit    = 63
    not_applicable      = "N/A"
  }

  environment_map = {
    sandbox     = "sbox"
    development = "dev"
    test        = "test"
    production  = "prod"
  }
  regex_replace_chars = local.defaults.regex_replace_chars
  id_delimiter        = local.defaults.id_delimiter
  replacement         = local.defaults.replacement
  id_length_limit     = local.defaults.id_length_limit
  id_hash_length      = local.defaults.id_hash_length
  tag_delimiter       = local.defaults.tag_delimiter
  tag_length_limit    = local.defaults.tag_length_limit
  not_applicable      = local.defaults.not_applicable

  # Merging of inputs from parent context, if supplied, and this context's overrides
  input = {
    enabled            = var.enabled == null ? var.context.enabled : var.enabled
    organization       = var.organization == null ? var.context.organization : var.organization
    cloud_provider     = var.cloud_provider == null ? var.context.cloud_provider : var.cloud_provider
    parent_name        = var.parent_name == null ? var.context.parent_name : var.parent_name
    namespace          = var.namespace == null ? var.context.namespace : var.namespace
    name               = var.name == null ? var.context.name : var.name
    attributes         = compact(distinct(concat(coalesce(var.context.attributes, []), coalesce(var.attributes, []))))
    environment        = var.environment == null ? var.context.environment : var.environment
    env_subtype        = var.env_subtype == null ? var.context.env_subtype : var.env_subtype
    project_owners     = var.project_owners == null ? var.context.project_owners : var.project_owners
    project            = var.project == null ? var.context.project : var.project
    project_type       = var.project_type == null ? var.context.project_type : var.project_type
    code_owners        = var.code_owners == null ? var.context.code_owners : var.code_owners
    data_owners        = var.data_owners == null ? var.context.data_owners : var.data_owners
    availability       = var.availability == null ? var.context.availability : var.availability
    deployer           = var.deployer == null ? var.context.deployer : var.deployer
    deletion_date      = var.deletion_date == null ? var.context.deletion_date : var.deletion_date
    confidentiality    = var.confidentiality == null ? var.context.confidentiality : var.confidentiality
    data_regs          = var.data_regs == null ? var.context.data_regs : var.data_regs
    security_review    = var.security_review == null ? var.context.security_review : var.security_review
    privacy_review     = var.privacy_review == null ? var.context.privacy_review : var.privacy_review
    tags               = merge(var.context.tags, var.tags)
    aws_region_codes   = var.aws_region_codes == null ? var.context.aws_region_codes : var.aws_region_codes
    azure_region_codes = var.azure_region_codes == null ? var.context.azure_region_codes : var.azure_region_codes
    gcp_region_codes   = var.gcp_region_codes == null ? var.context.gcp_region_codes : var.gcp_region_codes
  }

  env = lookup(local.environment_map, local.input.environment, "sbox")
  stage = local.input.env_subtype == "" || local.input.env_subtype == local.not_applicable ? (
    local.env
    ) : (
    join("", [local.env, local.input.env_subtype])
  )
  enabled = local.input.enabled == null ? true : local.input.enabled

  ns_raw  = join(local.id_delimiter, [local.input.organization, local.input.cloud_provider, local.input.namespace])
  ns_full = lower(replace(local.ns_raw, local.regex_replace_chars, local.replacement))
  name_prefix = join("", [
    local.input.organization,
    local.id_delimiter,
    local.input.cloud_provider,
    local.id_delimiter
  ])
  normalized_parent = trimprefix(local.input.parent_name, local.name_prefix)
  base_nameparts = local.normalized_parent == "" ? (
    [local.input.organization, local.input.cloud_provider, local.input.namespace, local.stage, local.input.name]
    ) : (
    [local.input.organization, local.input.cloud_provider, local.normalized_parent, local.input.name]
  )
  nameparts = concat(local.base_nameparts, local.input.attributes)
  id_raw    = join(local.id_delimiter, local.nameparts)
  id_full   = lower(replace(local.id_raw, local.regex_replace_chars, local.replacement))
  # Calculate shortened id to use if full id is too long
  delimiter_length          = length(local.id_delimiter)
  id_truncated_length_limit = local.id_length_limit - (local.id_hash_length + local.delimiter_length)
  id_truncated = local.id_truncated_length_limit <= 0 ? (
    ""
    ) : (
    "${trimsuffix(substr(local.id_full, 0, local.id_truncated_length_limit), local.id_delimiter)}${local.id_delimiter}"
  )
  id_hash_plus = lower("${md5(local.id_full)}qrstuvwxyz")
  id_hash      = replace(local.id_hash_plus, local.regex_replace_chars, local.replacement)
  id_short     = substr("${local.id_truncated}${local.id_hash}", 0, local.id_length_limit)
  id           = length(local.id_full) > local.id_length_limit ? local.id_short : local.id_full

  env_full = local.input.env_subtype == "" ? (
    local.input.environment
    ) : (
    join(local.id_delimiter, [local.input.environment, local.input.env_subtype])
  )

  regions_map = merge(local.input.aws_region_codes, local.input.azure_region_codes, local.input.gcp_region_codes)

  sandbox_dt = local.stage == "sbox" ? timeadd(timestamp(), "2160h") : local.not_applicable
  delete_dt  = local.input.deletion_date == null ? local.sandbox_dt : local.input.deletion_date

  raw_tags = merge({
    dbs-projectowners = length(local.input.project_owners) > 0 ? (
      join(local.tag_delimiter, local.input.project_owners)
      ) : (
      local.not_applicable
    )
    dbs-project     = local.input.project
    dbs-projecttype = local.input.project_type
    dbs-codeowners = length(local.input.code_owners) > 0 ? (
      join(local.tag_delimiter, local.input.code_owners)
      ) : (
      local.not_applicable
    )
    dbs-dataowners = length(local.input.data_owners) > 0 ? (
      join(local.tag_delimiter, local.input.data_owners)
      ) : (
      local.not_applicable
    )
    dbs-environment     = local.env_full
    dbs-availability    = local.input.availability
    dbs-deployer        = local.input.deployer
    dbs-deletiondate    = local.delete_dt
    dbs-confidentiality = local.input.confidentiality
    dbs-dataregulations = length(local.input.data_regs) > 0 ? (
      join(local.tag_delimiter, local.input.data_regs)
      ) : (
      local.not_applicable
    )
    dbs-securityreview = local.input.security_review
    dbs-privacyreview  = local.input.privacy_review
  }, local.input.tags)
  tag_names = keys(local.raw_tags)
  tags = { for k in local.tag_names : k =>
    length(local.raw_tags[k]) > local.tag_length_limit ? (
      substr(local.raw_tags[k], 0, local.tag_length_limit)
      ) : (
      local.raw_tags[k]
    )
  }
  tags_all = merge({
    Name = local.id
  }, local.tags)

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) : merge(
      {
        key                 = key
        value               = local.tags[key]
        propagate_at_launch = "true"
    })
  ])

  # Merging of inputs from parent context, if supplied, and this context's overrides
  output_context = {
    enabled            = local.enabled
    organization       = local.input.organization
    cloud_provider     = local.input.cloud_provider
    parent_name        = local.id
    namespace          = local.input.namespace
    name               = local.input.name
    attributes         = local.input.attributes
    environment        = local.input.environment
    env_subtype        = local.input.env_subtype
    project_owners     = local.input.project_owners
    project            = local.input.project
    project_type       = local.input.project_type
    code_owners        = local.input.code_owners
    data_owners        = local.input.data_owners
    availability       = local.input.availability
    deployer           = local.input.deployer
    deletion_date      = local.input.deletion_date
    confidentiality    = local.input.confidentiality
    data_regs          = local.input.data_regs
    security_review    = local.input.security_review
    privacy_review     = local.input.privacy_review
    tags               = local.input.tags
    aws_region_codes   = local.input.aws_region_codes
    azure_region_codes = local.input.azure_region_codes
    gcp_region_codes   = local.input.gcp_region_codes
  }

}
