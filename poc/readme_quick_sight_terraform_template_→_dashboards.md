# QuickSight Terraform (Template → Dashboards)

This repository provisions and manages **Amazon QuickSight** resources with Terraform:

- Creates/owns a **Template** sourced from an existing **Analysis**
- Creates one or more **Dashboards** from that Template
- Manages **permissions** (so you can see the dashboards)
- (Optional) Adds a **daily SPICE refresh** schedule for the dataset

> We started from an existing Analysis and Dataset in `us-east-1`, imported the live Template/Dashboard into Terraform state, then reconciled configuration so everything is code-managed.

---

## Prerequisites
- Terraform ≥ **1.6**
- AWS provider **~> 5.60**
- AWS credentials with QuickSight Admin rights in the target account/region
- Existing QuickSight **Analysis** and **DataSet** (IDs known)

---

## Project layout
```
qs-template-dash/
├─ README.md                     # ← this file
├─ .gitignore
├─ Makefile
├─ versions.tf                   # provider + terraform versions
├─ variables.tf                  # inputs
├─ locals.tf                     # derived ARNs
├─ main.tf                       # template + dashboards
├─ outputs.tf
├─ terraform.tfvars              # your values
└─ bootstrap/                    # (optional) remote state infra
   └─ main.tf
```

---

## Quick start
1. **Clone** and enter the folder.
2. Create `terraform.tfvars` (example below) with your IDs and names.
3. Initialize Terraform:
   ```bash
   make init
   ```
4. **Import** the existing QuickSight resources (so Terraform manages them):
   ```bash
   terraform import aws_quicksight_template.from_analysis 942486875728,saas-sales-template
   terraform import aws_quicksight_dashboard.from_template 942486875728,saas-sales-dash-tf
   ```
5. Review & apply:
   ```bash
   make plan
   make apply
   ```
6. Verify with CLI:
   ```bash
   ACCOUNT=942486875728 REGION=us-east-1
   aws quicksight describe-template  --aws-account-id $ACCOUNT --template-id saas-sales-template --region $REGION --query 'Template.Version.Status'
   aws quicksight describe-dashboard --aws-account-id $ACCOUNT --dashboard-id saas-sales-dash-tf --region $REGION --query 'Dashboard.Version.Status'
   ```

---

## `terraform.tfvars` (example)
```hcl
account_id  = "942486875728"
region      = "us-east-1"

# Existing resources
analysis_id = "saas-sales-from-tf"
dataset_id  = "2493a4d0-dace-4c24-acf2-1bf2d28f3059"

# Managed resources
template_id  = "saas-sales-template"      # (already exists; imported)
dashboard_id = "saas-sales-dash-tf"       # (already exists; imported)

# Mapping must match the Analysis placeholder
dataset_placeholder = "saas_sales_ml"

# Display names (cosmetic)
template_name  = "SaaS Sales Template"
dashboard_name = "SaaS Sales Dashboard (Terraform)"

# Version labels (cosmetic)
template_version_description  = "v1 - created from analysis"
dashboard_version_description = "v1 - created from template"
```

---

## What `main.tf` does
- **Template** from existing **Analysis**:
  - Uses `source_entity { source_analysis { ... data_set_references { ... }}}`
  - Requires `version_description`
- **Dashboard** from that **Template**:
  - Uses `source_entity { source_template { ... data_set_references { ... }}}`
  - Requires `version_description`
  - Adds a **permissions** block for your QuickSight user: `arn:aws:quicksight:<region>:<acct>:user/default/antonios`

> Note: Changing *IDs* (`template_id`, `dashboard_id`) will create new resources. Changing *names* only renames in the console.

---

## Create a **second** dashboard from the same Template
Append this resource to `main.tf` and apply:
```hcl
resource "aws_quicksight_dashboard" "from_template_v2" {
  aws_account_id      = var.account_id
  dashboard_id        = "saas-sales-dash-tf-2"    # NEW ID
  name                = "SaaS Sales Dashboard (TF v2)"
  version_description = "v1 - created from template"

  source_entity {
    source_template {
      arn = aws_quicksight_template.from_analysis.arn
      data_set_references {
        data_set_placeholder = var.dataset_placeholder
        data_set_arn         = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
      }
    }
  }

  # Give your user permissions
  permissions {
    principal = "arn:aws:quicksight:${var.region}:${var.account_id}:user/default/antonios"
    actions = [
      "quicksight:DeleteDashboard",
      "quicksight:DescribeDashboard",
      "quicksight:DescribeDashboardPermissions",
      "quicksight:ListDashboardVersions",
      "quicksight:QueryDashboard",
      "quicksight:UpdateDashboard",
      "quicksight:UpdateDashboardPermissions",
      "quicksight:UpdateDashboardPublishedVersion",
    ]
  }
}
```

List dashboards:
```bash
ACCOUNT=942486875728 REGION=us-east-1
aws quicksight list-dashboards --aws-account-id $ACCOUNT --region $REGION \
  --query 'DashboardSummaryList[].{Id:DashboardId,Name:Name}' --output table
```

---

## Optional: dataset SPICE refresh schedule (daily 06:00 UTC)
```hcl
resource "aws_quicksight_refresh_schedule" "saas_sales_ml_daily" {
  aws_account_id = var.account_id
  data_set_id    = var.dataset_id

  schedule {
    schedule_id   = "saas-sales-ml-daily"
    refresh_type  = "FULL_REFRESH"
    schedule_frequency {
      interval        = "DAILY"
      time_of_the_day = "06:00"
      timezone        = "UTC"
    }
  }
}
```

---

## Optional: remote state (S3 + DynamoDB)
1. `cd bootstrap && terraform init && terraform apply -auto-approve && cd ..`
2. Create `backend.tf` and migrate:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "qs-tf-state-942486875728-us-east-1"
       key            = "quicksight/qs-template-dash/terraform.tfstate"
       region         = "us-east-1"
       dynamodb_table = "qs-tf-lock"
       encrypt        = true
     }
   }
   ```
   ```bash
   terraform init -migrate-state
   ```

---

## How to find IDs
- **Analysis**: open in console → URL segment after `/analyses/`
- **Dashboard**: open in console → URL segment after `/dashboards/`
- **Template**: use CLI (no console page):
  ```bash
  aws quicksight list-templates --aws-account-id $ACCOUNT --region $REGION \
    --query 'TemplateSummaryList[].{Id:TemplateId,Name:Name,Arn:Arn}'
  ```

---

## Troubleshooting
- **409 ResourceExistsException** when creating template/dashboard
  - It already exists. **Import** it: `terraform import aws_quicksight_template.from_analysis <acct>,<template_id>`
- **Permissions disappeared** and you can’t see the dashboard in console
  - Add a `permissions` block for your user (as in `main.tf`) or re-grant via CLI `update-dashboard-permissions`.
- **Invalid expression / single-line variable block** errors
  - Use multi-line `variable { ... }` blocks; don’t put `type` and `default` on the same line.
- **Insufficient/unsupported `data_set_references`**
  - Use nested **blocks**, not inline maps. See `main.tf` examples.
- **Missing required argument `version_description`**
  - Required by both `aws_quicksight_template` and `aws_quicksight_dashboard` resources.
- **Placeholder mismatch**
  - `dataset_placeholder` must match exactly what the Analysis used (here: `saas_sales_ml`).

---

## Makefile targets
```make
init:   terraform init
plan:   terraform plan -var-file=terraform.tfvars
apply:  terraform apply -auto-approve -var-file=terraform.tfvars
destroy: terraform destroy -auto-approve -var-file=terraform.tfvars
fmt:    terraform fmt -recursive
```

---

## Safety tips
- Consider protecting live assets:
  ```hcl
  lifecycle { prevent_destroy = true }
  ```
- Prefer **new IDs** to create additional dashboards rather than renaming the existing ID.

---

## Clean up
Destroy only if you intend to delete the QuickSight resources:
```bash
make destroy
```

> Keep in mind: destroying dashboards/templates here will remove them from your QuickSight account.

