variable "account_id" { type = string }
variable "region" { type = string }

# Existing resources
variable "analysis_id" { type = string } # e.g., "saas-sales-from-tf"
variable "dataset_id" { type = string }  # default dataset for mappings

# New resources
variable "template_id" { type = string } # e.g., "saas-sales-template"

# Optional tweaks
variable "dataset_placeholder" {
  type    = string
  default = "saas_sales_ml"
}

variable "readers_group_name" {
  type    = string
  default = null # set to "Readers" to enable viewer permissions for that group
}

variable "template_name" {
  type    = string
  default = "SaaS Sales Template (from analysis)"
}

variable "dashboard_version_description" {
  type    = string
  default = "v1 - created from template"
}

variable "template_version_description" {
  type    = string
  default = "v1 - created from analysis"
}

# Define your dashboards here in one place
# Key = dashboard_id; value = name + (optional) version_description, dataset_id
variable "dashboards" {
  type = map(object({
    name                = string
    version_description = optional(string)
    dataset_id          = optional(string)
  }))

  # Example defaults (adjust or move to *.tfvars)
  default = {
    "saas-sales-dash-tf" = {
      name = "SaaS Sales Dashboard (Terraform)"
    }
    "saas-sales-dash-tf-2" = {
      name                = "SaaS Sales Dashboard (TF v2)"
      version_description = "v1 - created from template"
    }
    "saas-sales-dash-for-client-2" = {
      name       = "SaaS Sales Dashboard for Client 2"
      dataset_id = "2493a4d0-dace-4c24-acf2-1bf2d28f3059" # override if needed
    }
  }
}
