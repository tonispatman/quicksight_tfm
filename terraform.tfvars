account_id = "942486875728"
region     = "us-east-1"

# <-- the new template you just created via CLI step 2 -->
template_id = "saas-sales-template-stg"

# Option 1 (recommended): use alias
template_alias_name     = "stg"
template_version_number = null

# Option 2: no alias, pin the version number (usually 1 right after create)
# template_alias_name     = null
# template_version_number = 1

dataset_id          = "2493a4d0-dace-4c24-acf2-1bf2d28f3059" # same dataset for this POC
dataset_placeholder = "saas_sales_ml"

dashboard_id   = "saas-sales-dash-stg"
dashboard_name = "SaaS Sales Dashboard (STG from imported template)"

owner_user_name = "antonios"
