variable "account_id" { type = string }
variable "region" { type = string }

# Existing resources
variable "analysis_id" { type = string } # e.g. "saas-sales-from-tf"
variable "dataset_id" { type = string }  # e.g. "2493a4d0-dace-4c24-acf2-1bf2d28f3059"

# New resources
variable "template_id" { type = string }  # e.g. "saas-sales-template"
variable "dashboard_id" { type = string } # e.g. "saas-sales-dash-tf-2"

# Optional tweaks
variable "dataset_placeholder" {
  type    = string
  default = "saas_sales_ml"
}

variable "readers_group_name" {
  type    = string
  default = null
}

variable "template_name" {
  type    = string
  default = "SaaS Sales Template (from analysis)"
}

variable "dashboard_name" {
  type    = string
  default = "SaaS Sales Dashboard (from template)"
}

variable "template_version_description" {
  type    = string
  default = "v1 - created from analysis"
}

variable "dashboard_version_description" {
  type    = string
  default = "v1 - created from template"
}
