variable "account_id"  { type = string }
variable "region"      { type = string }

# NEW template we just created with CLI
variable "template_id" { type = string }              # e.g., "saas-sales-template-stg"
variable "template_alias_name" { type = string, default = null }   # e.g., "stg" (optional)
variable "template_version_number" { type = number, default = null } # use if not using alias

# Dataset you want to bind (must match the template’s placeholder schema)
variable "dataset_id"  { type = string }              # e.g., "2493a4d0-dace-4c24-acf2-1bf2d28f3059"
variable "dataset_placeholder" { type = string, default = "saas_sales_ml" }

# Dashboard to create
variable "dashboard_id"   { type = string }           # e.g., "saas-sales-dash-stg"
variable "dashboard_name" { type = string, default = "SaaS Sales Dashboard (Imported Template POC)" }

# Owner/editor of the dashboard
variable "owner_user_name" { type = string, default = "antonios" }
