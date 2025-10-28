variable "account_id" { type = string }
variable "region" { type = string }

# Existing resources
variable "analysis_id" { type = string } # e.g., "saas-sales-from-tf"
variable "dataset_id" { type = string }  # default dataset ID for mappings (not ARN)

# Template config
variable "template_id" {
  type = string # e.g., "saas-sales-template"
}

variable "template_name" {
  type    = string
  default = "SaaS Sales Template (from analysis)"
}

variable "template_version_description" {
  type    = string
  default = "v1 - created from analysis"
}

# Placeholders and defaults
variable "dataset_placeholder" {
  type    = string
  default = "saas_sales_ml"
}

variable "dashboard_version_description" {
  type    = string
  default = "v1 - created from template"
}

# Permissions config
variable "owner_user_name" {
  type    = string
  default = "antonios" # QuickSight username in the 'default' namespace
}

variable "readers_group_name" {
  type    = string
  default = null # set to "Readers" to enable view perms for that group
}

# Define dashboards in one place
# Key = dashboard_id; value = name + (optional) version_description, dataset (ID or ARN)
variable "dashboards" {
  type = map(object({
    name                = string
    version_description = optional(string)
    dataset             = optional(string) # dataset ID or full ARN
  }))

  # Example defaults (override in *.tfvars for real usage)
  default = {
    "saas-sales-dash-tf" = {
      name = "SaaS Sales Dashboard (Terraform)"
    }
    "saas-sales-dash-tf-2" = {
      name                = "SaaS Sales Dashboard (TF v2)"
      version_description = "v1 - created from template"
    }
    "saas-sales-dash-for-client-2" = {
      name    = "SaaS Sales Dashboard for Client 2"
      dataset = "2493a4d0-dace-4c24-acf2-1bf2d28f3059" # override with ID or full ARN
    }
  }
}
