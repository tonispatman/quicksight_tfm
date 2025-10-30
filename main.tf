resource "aws_quicksight_dashboard" "poc_from_imported_template" {
  aws_account_id      = var.account_id
  dashboard_id        = var.dashboard_id
  name                = var.dashboard_name
  version_description = "POC from imported template"

  source_entity {
    source_template {
      # If you set var.template_alias_name (e.g., "stg"), local.template_arn resolves to:
      # arn:aws:quicksight:REGION:ACCOUNT:template/TEMPLATE_ID/alias/stg
      # Otherwise it’s the base template ARN.
      arn = local.template_arn

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

resource "aws_quicksight_dashboard" "poc_from_imported_template_2" {
  aws_account_id      = var.account_id
  dashboard_id        = "saas-sales-dash-stg-2"
  name                = "SaaS Sales Dashboard (STG #2)"
  version_description = "POC from imported template (second)"

  source_entity {
    source_template {
      arn = local.template_arn

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


