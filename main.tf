resource "aws_quicksight_dashboard" "poc_from_imported_template" {
  aws_account_id      = var.account_id
  dashboard_id        = var.dashboard_id
  name                = var.dashboard_name
  version_description = "POC from imported template"

  source_entity {
    source_template {
      arn = local.template_arn

      # If you're NOT using an alias, pin a version by setting template_version_number (e.g., 1).
      # If alias is set, leave this null.
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
