variable "context" {
  description = <<-EOT
    Single object for setting entire context at once.
    See description of individual variables for details.
    Leave string and numeric variables as `null` to use default value.
    Individual variable settings (non-null) override settings in context object,
    except for attributes and tags which are merged.
  EOT
  type        = any
  default = {
    enabled         = true
    organization    = "dbs"
    cloud_provider  = "dc"
    parent_name     = ""
    namespace       = "dbs"
    name            = "missing"
    attributes      = []
    environment     = "sandbox"
    env_subtype     = ""
    project_owners  = []
    project         = "N/A"
    project_type    = "N/A"
    code_owners     = []
    data_owners     = []
    availability    = "preemptable"
    deployer        = "Terraform"
    deletion_date   = null
    confidentiality = "confidential"
    data_regs       = []
    security_review = "N/A"
    privacy_review  = "N/A"
    tags            = {}
    aws_region_codes = {
      us-east-1      = "use1"  # US East (N. Virginia)
      us-east-2      = "use2"  # US East (Ohio)
      us-west-1      = "usw1"  # US West (N. California)
      us-west-2      = "usw2"  # US West (Oregon)
      ap-east-1      = "ape1"  # Asia Pacific (Hong Kong)
      ap-south-1     = "aps1"  # Asia Pacific (Mumbai)
      ap-northeast-2 = "apn2"  # Asia Pacific (Seoul)
      ap-northeast-1 = "apn1"  # Asia Pacific (Tokyo)
      ap-southeast-1 = "apse1" # Asia Pacific (Singapore)
      ap-southeast-2 = "apse2" # Asia Pacific (Sydney)
      ca-central-1   = "cac1"  # Canada (Central)
      cn-north-1     = "cnn1"  # China (Beijing)
      cn-northwest-1 = "cnnw1" # China (Ningxia)
      eu-central-1   = "euc1"  # EU (Frankfurt)
      eu-west-1      = "euw1"  # EU (Ireland)
      eu-west-2      = "euw2"  # EU (London)
      eu-west-3      = "euw3"  # EU (Paris)
      eu-north-1     = "eun1"  # EU (Stockholm)
      sa-east-1      = "sae1"  # South America (Sao Paulo)
      us-gov-east-1  = "usge1" # AWS GovCloud (US-East)
      us-gov-west-1  = "usgw1" # AWS GovCloud (US)
    }
    azure_region_codes = {
      "Central US"       = "CUS"
      "East US"          = "EUS"
      "East US 2"        = "EUS2"
      "East US 3"        = "EUS3"
      "North Central US" = "NCUS"
      "South Central US" = "SCUS"
      "West Central US"  = "WCUS"
      "West US"          = "WUS"
      "West US 2"        = "WUS2"
      "West US 3"        = "WUS3"
      "US DoD Central"   = "USDC"
      "US DoD East"      = "USDE"
      "US Gov Arizona"   = "USGA"
      "US Gov Texas"     = "USGT"
      "US Gov Virginia"  = "USGV"
      "Canada Central"   = "CC"
      "Canada East"      = "CE"
      "Mexico Central"   = "MC"
      "Brazil South"     = "BS"
      "Chile Central"    = "CHC"
    }
    gcp_region_codes = {
      us-west1                = "usw1"  # Oregon
      us-west2                = "usw2"  # Los Angeles
      us-west3                = "usw3"  # Salt Lake City
      us-west4                = "usw4"  # Las Vegas
      us-central1             = "usc1"  # Iowa
      us-east1                = "use1"  # South Carolina
      us-east4                = "use4"  # N. Virginia
      northamerica-northeast1 = "nane1" # Montreal
      southamerica-east1      = "sae1"  # Sao Paulo
    }
  }

  validation {
    condition     = contains(["dbs", "dl"], var.context.organization)
    error_message = "Allowed values: `dbs`, `dl`."
  }
  validation {
    condition     = contains(["dc", "aws", "az", "gcp", "oci", "ibm", "do", "vul", "ali", "cv"], var.context.cloud_provider)
    error_message = "Allowed values: `dc`, `aws`, `az`, `gcp`, `oci`, `ibm`, `do`, `vul`, `ali`, `cv`."
  }
  validation {
    condition     = trimspace(var.context.namespace) != ""
    error_message = "Non-blank value required."
  }
  validation {
    condition     = length(trimspace(var.context.name)) >= 2
    error_message = "At least 2 characters in length required."
  }
  validation {
    condition     = contains(["sandbox", "development", "test", "production"], var.context.environment)
    error_message = "Allowed values: `sandbox`, `development`, `test`, `production`."
  }
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = null
}

variable "organization" {
  description = "Organization [dbs, dl]."
  type        = string
  default     = null

  validation {
    condition     = var.organization == null ? true : contains(["dbs", "dl"], var.organization)
    error_message = "Allowed values: `dbs`, `dl`."
  }
}

variable "cloud_provider" {
  description = "Public/private cloud provider [dc, aws, az, gcp, oci, ibm, do, vul, ali, cv]."
  type        = string
  default     = null

  validation {
    condition = var.cloud_provider == null ? (
      true
      ) : (
      contains(["dc", "aws", "az", "gcp", "oci", "ibm", "do", "vul", "ali", "cv"], var.cloud_provider)
    )
    error_message = "Allowed values: `dc`, `aws`, `az`, `gcp`, `oci`, `ibm`, `do`, `vul`, `ali`. `cv`."
  }
}

variable "parent_name" {
  description = "Name (less cp) of one level up or associated Active Directory group."
  type        = string
  default     = null
}

variable "namespace" {
  description = "One level up group name plus optional additional differentiation."
  type        = string
  default     = null

  validation {
    condition     = var.namespace == null ? true : trimspace(var.namespace) != ""
    error_message = "Non-blank value required."
  }
}

variable "name" {
  description = "Unique name within that particular hierarchy level and resource type."
  type        = string
  default     = null

  validation {
    condition     = var.name == null ? true : length(trimspace(var.name)) >= 2
    error_message = "At least 2 characters in length required."
  }
}

variable "attributes" {
  description = "Distinguishes individual instances of the same type and purpose with an instance number or special purpose name."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Standard name from enumerated list for the deployment environment. (sandbox, development, test, production)"
  type        = string
  default     = null

  validation {
    condition = var.environment == null ? (
      true
      ) : (
      contains(["sandbox", "development", "test", "production"], var.environment)
    )
    error_message = "Allowed values: `sandbox`, `development`, `test`, `production`."
  }
}

variable "env_subtype" {
  description = "Additional designator for sub-classification of the deployment environment if needed or else blank to ignore."
  type        = string
  default     = null
}

variable "project_owners" {
  description = "List of email addresses to contact with billing questions."
  type        = list(string)
  default     = null
}

variable "project" {
  description = "Identifier for the Unanet project this resource should be billed to."
  type        = string
  default     = null
}

variable "project_type" {
  description = "The Unanet project type."
  type        = string
  default     = null
}

variable "code_owners" {
  description = "List of email addresses to contact  for application issue resolution."
  type        = list(string)
  default     = null
}

variable "data_owners" {
  description = "List of email addresses to contact for data governance issues."
  type        = list(string)
  default     = null
}

variable "availability" {
  description = "Standard name from enumerated list of availability requirements. (always_on, business_hours, preemptable)"
  type        = string
  default     = null

  validation {
    condition = var.availability == null ? (
      true
      ) : (
      contains(["always_on", "business_hours", "preemptable"], var.availability)
    )
    error_message = "Allowed values: `always_on`, `business_hours`, `preemptable`."
  }
}

variable "deployer" {
  description = "ID of the CI/CD platform or person who last updated the resource."
  type        = string
  default     = null
}

variable "deletion_date" {
  description = "Date resource should be deleted if still running."
  type        = string
  default     = null
}

variable "confidentiality" {
  description = "Standard name from enumerated list for data confidentiality. (public, confidential, client, private)"
  type        = string
  default     = null

  validation {
    condition = var.confidentiality == null ? (
      true
      ) : (
      contains(["public", "confidential", "client", "private"], var.confidentiality)
    )
    error_message = "Allowed values: `public`, `confidential`, `client`, `private`."
  }
}

variable "data_regs" {
  description = "List of regulations which resource data must comply with."
  type        = list(string)
  default     = null
}

variable "security_review" {
  description = "ID or date of last security review or audit"
  type        = string
  default     = null
}

variable "privacy_review" {
  description = "ID or date of last data privacy review or audit."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  type        = map(string)
  default     = {}
}

variable "aws_region_codes" {
  description = "The abbreviated name of the AWS region, required to form unique resource names"
  default     = null
}

variable "azure_region_codes" {
  description = "The abbreviated name of the Azure region, required to form unique resource names"
  default     = null
}

variable "gcp_region_codes" {
  description = "The abbreviated name of the GCP region, required to form unique resource names"
  default     = null
}
