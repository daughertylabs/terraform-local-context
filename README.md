# Daugherty Labs Naming Context Terraform Module

Terraform module for constructing resource names and tags/labels conforming to
Daugherty Labs' standards.

## Usage

```hcl
module "this" {
  source = "https://github.com/daughertylabs/terraform-local-context.git"

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
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0, < 2.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Distinguishes individual instances of the same type and purpose with an instance number or special purpose name. | `list(string)` | `[]` | no |
| availability | Standard name from enumerated list of availability requirements. (always\_on, business\_hours, preemptable) | `string` | `null` | no |
| aws\_region\_codes | The abbreviated name of the AWS region, required to form unique resource names | `any` | `null` | no |
| azure\_region\_codes | The abbreviated name of the Azure region, required to form unique resource names | `any` | `null` | no |
| cloud\_provider | Public/private cloud provider [dc, aws, az, gcp, oci, ibm, do, vul, ali, cv]. | `string` | `null` | no |
| code\_owners | List of email addresses to contact  for application issue resolution. | `list(string)` | `null` | no |
| confidentiality | Standard name from enumerated list for data confidentiality. (public, confidential, client, private) | `string` | `null` | no |
| context | Single object for setting entire context at once. See description of individual variables for details. Leave string and numeric variables as `null` to use default value. Individual variable settings (non-null) override settings in context object, except for attributes and tags which are merged. | `any` | ```{ "attributes": [], "availability": "preemptable", "aws_region_codes": { "ap-east-1": "ape1", "ap-northeast-1": "apn1", "ap-northeast-2": "apn2", "ap-south-1": "aps1", "ap-southeast-1": "apse1", "ap-southeast-2": "apse2", "ca-central-1": "cac1", "cn-north-1": "cnn1", "cn-northwest-1": "cnnw1", "eu-central-1": "euc1", "eu-north-1": "eun1", "eu-west-1": "euw1", "eu-west-2": "euw2", "eu-west-3": "euw3", "sa-east-1": "sae1", "us-east-1": "use1", "us-east-2": "use2", "us-gov-east-1": "usge1", "us-gov-west-1": "usgw1", "us-west-1": "usw1", "us-west-2": "usw2" }, "azure_region_codes": { "Brazil South": "BS", "Canada Central": "CC", "Canada East": "CE", "Central US": "CUS", "Chile Central": "CHC", "East US": "EUS", "East US 2": "EUS2", "East US 3": "EUS3", "Mexico Central": "MC", "North Central US": "NCUS", "South Central US": "SCUS", "US DoD Central": "USDC", "US DoD East": "USDE", "US Gov Arizona": "USGA", "US Gov Texas": "USGT", "US Gov Virginia": "USGV", "West Central US": "WCUS", "West US": "WUS", "West US 2": "WUS2", "West US 3": "WUS3" }, "cloud_provider": "dc", "code_owners": [], "confidentiality": "confidential", "data_owners": [], "data_regs": [], "deletion_date": null, "deployer": "Terraform", "enabled": true, "env_subtype": "", "environment": "sandbox", "gcp_region_codes": { "northamerica-northeast1": "nane1", "southamerica-east1": "sae1", "us-central1": "usc1", "us-east1": "use1", "us-east4": "use4", "us-west1": "usw1", "us-west2": "usw2", "us-west3": "usw3", "us-west4": "usw4" }, "name": "missing", "namespace": "dbs", "organization": "dbs", "parent_name": "", "privacy_review": "N/A", "project": "N/A", "project_owners": [], "project_type": "N/A", "security_review": "N/A", "tags": {} }``` | no |
| data\_owners | List of email addresses to contact for data governance issues. | `list(string)` | `null` | no |
| data\_regs | List of regulations which resource data must comply with. | `list(string)` | `null` | no |
| deletion\_date | Date resource should be deleted if still running. | `string` | `null` | no |
| deployer | ID of the CI/CD platform or person who last updated the resource. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| env\_subtype | Additional designator for sub-classification of the deployment environment if needed or else blank to ignore. | `string` | `null` | no |
| environment | Standard name from enumerated list for the deployment environment. (sandbox, development, test, production) | `string` | `null` | no |
| gcp\_region\_codes | The abbreviated name of the GCP region, required to form unique resource names | `any` | `null` | no |
| name | Unique name within that particular hierarchy level and resource type. | `string` | `null` | no |
| namespace | One level up group name plus optional additional differentiation. | `string` | `null` | no |
| organization | Organization [dbs, dl]. | `string` | `null` | no |
| parent\_name | Name (less cp) of one level up or associated Active Directory group. | `string` | `null` | no |
| privacy\_review | ID or date of last data privacy review or audit. | `string` | `null` | no |
| project | Identifier for the Unanet project this resource should be billed to. | `string` | `null` | no |
| project\_owners | List of email addresses to contact with billing questions. | `list(string)` | `null` | no |
| project\_type | The Unanet project type. | `string` | `null` | no |
| security\_review | ID or date of last security review or audit | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| context | Merged but otherwise unmodified input to this module, to be used as context input to other modules. |
| env\_code | Short code for the deployment environment. |
| namespace\_full | Fully-qualified namespace for resources in the context. |
| name\_prefix | Disambiguated ID or name prefix for resources in the context. |
| normalized\_context | Normalized context of this module |
| region\_code\_map | Mappings of cloud provider region ids to standard short codes. |
| tags | Normalized tag map. |
| tags\_as\_list\_of\_maps | Additional tags as a list of maps, which can be used in several AWS resources |
| tags\_with\_name | normalized tag map including Name tag. |
