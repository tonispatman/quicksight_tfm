variable "account_id" { type = string }
variable "region" { type = string }

variable "template_id" { type = string } # e.g. "saas-sales-template-stg"

variable "template_alias_name" {
  type    = string
  default = "stg" # set null if you don't want to use an alias
}

# Leave this if you ever decide NOT to use alias; otherwise ignore it.
variable "template_version_number" {
  type    = number
  default = null
}

variable "dataset_id" { type = string }

variable "dataset_placeholder" {
  type    = string
  default = "saas_sales_ml"
}

variable "dashboard_id" { type = string }
variable "dashboard_name" {
  type    = string
  default = "SaaS Sales Dashboard (STG from imported template)"
}

variable "owner_user_name" {
  type    = string
  default = "antonios"
}
