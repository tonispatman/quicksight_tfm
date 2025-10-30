variable "account_id" { type = string }
variable "region" { type = string }

# NEW template we created via CLI
variable "template_id" { type = string } # e.g. "saas-sales-template-stg"

# Prefer alias for simplicity; comment it out if you’ll pin by version
variable "template_alias_name" {
  type    = string
  default = "stg" # or null if you won't use an alias
}

# If not using alias, set this (e.g., 1 right after create) and set alias to null
variable "template_version_number" {
  type    = number
  default = null
}

variable "dataset_id" { type = string } # e.g. "2493a4d0-dace-4c24-acf2-1bf2d28f3059"

variable "dataset_placeholder" {
  type    = string
  default = "saas_sales_ml"
}

variable "dashboard_id" { type = string } # e.g. "saas-sales-dash-stg"
variable "dashboard_name" {
  type    = string
  default = "SaaS Sales Dashboard (STG from imported template)"
}

variable "owner_user_name" {
  type    = string
  default = "antonios"
}
