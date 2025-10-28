locals {
  analysis_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:analysis/${var.analysis_id}"

  owner_principal = "arn:aws:quicksight:${var.region}:${var.account_id}:user/default/antonios"

  # Define once, reuse everywhere
  owner_actions = [
    "quicksight:DeleteDashboard",
    "quicksight:DescribeDashboard",
    "quicksight:DescribeDashboardPermissions",
    "quicksight:ListDashboardVersions",
    "quicksight:QueryDashboard",
    "quicksight:UpdateDashboard",
    "quicksight:UpdateDashboardPermissions",
    "quicksight:UpdateDashboardPublishedVersion",
  ]

  # Minimal viewer set for a Readers group (optional)
  reader_actions = [
    "quicksight:DescribeDashboard",
    "quicksight:ListDashboardVersions",
    "quicksight:QueryDashboard",
  ]

  dashboard_permissions = concat(
    [
      {
        principal = local.owner_principal
        actions   = local.owner_actions
      }
    ],
    var.readers_group_name == null ? [] : [
      {
        principal = "arn:aws:quicksight:${var.region}:${var.account_id}:group/default/${var.readers_group_name}"
        actions   = local.reader_actions
      }
    ]
  )
}

# 1) Template from existing Analysis
resource "aws_quicksight_template" "from_analysis" {
  aws_account_id      = var.account_id
  template_id         = var.template_id
  name                = var.template_name
  version_description = var.template_version_description

  source_entity {
    source_analysis {
      arn = local.analysis_arn

      data_set_references {
        data_set_placeholder = var.dataset_placeholder
        data_set_arn         = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
      }
    }
  }
}

# 2) Dashboards from the same template (create many via for_each)
resource "aws_quicksight_dashboard" "from_template" {
  for_each = var.dashboards

  aws_account_id      = var.account_id
  dashboard_id        = each.key
  name                = each.value.name
  version_description = lookup(each.value, "version_description", var.dashboard_version_description)

  source_entity {
    source_template {
      arn = aws_quicksight_template.from_analysis.arn

      data_set_references {
        data_set_placeholder = var.dataset_placeholder

        # Per-dashboard dataset override; falls back to var.dataset_id
        data_set_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${lookup(each.value, "dataset_id", var.dataset_id)}"
      }
    }
  }

  # Reuse the same actions without repeating them
  dynamic "permissions" {
    for_each = local.dashboard_permissions
    content {
      principal = permissions.value.principal
      actions   = permissions.value.actions
    }
  }
}
