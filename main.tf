locals {
  template_base_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:template/${var.template_id}"
  template_arn      = var.template_alias_name != null
                    ? "${local.template_base_arn}/alias/${var.template_alias_name}"
                    : local.template_base_arn

  dataset_arn    = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
  owner_user_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:user/default/${var.owner_user_name}"
}

resource "aws_quicksight_dashboard" "from_imported_template" {
  aws_account_id      = var.account_id
  dashboard_id        = var.dashboard_id
  name                = var.dashboard_name
  version_description = "POC from imported template"

  source_entity {
    source_template {
      arn = local.template_arn

      # If you didn’t make an alias, pin the version explicitly
      dynamic "version_number" {
        for_each = var.template_alias_name == null && var.template_version_number != null ? [1] : []
        content {
          # HCL limitation: version_number is a simple attribute, so we assign via a separate attribute:
        }
      }
      # Workaround: set version_number only when provided
      # (Terraform block supports it directly as an argument)
      version_number = var.template_alias_name == null ? var.template_version_number : null

      data_set_references {
        data_set_placeholder = var.dataset_placeholder
        data_set_arn         = local.dataset_arn
      }
    }
  }

  permissions {
    principal = local.owner_user_arn
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
