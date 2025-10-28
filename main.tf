# --- QuickSight Template from existing Analysis ---
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

# --- Dashboards from the Template (supports many via for_each) ---
resource "aws_quicksight_dashboard" "from_template" {
  for_each = var.dashboards

  aws_account_id      = var.account_id
  dashboard_id        = each.key
  name                = each.value.name
  version_description = try(each.value.version_description, var.dashboard_version_description)

  source_entity {
    source_template {
      arn = aws_quicksight_template.from_analysis.arn

      data_set_references {
        data_set_placeholder = var.dataset_placeholder
        # ONE-LINER: accept ARN or ID (falls back to var.dataset_id)
        data_set_arn = startswith(try(each.value.dataset, ""), "arn:aws:quicksight:") ? try(each.value.dataset, "") : format("arn:aws:quicksight:%s:%s:dataset/%s", var.region, var.account_id, try(each.value.dataset, var.dataset_id))
      }
    }
  }

  # Reuse shared permissions (owner + optional Readers group)
  dynamic "permissions" {
    for_each = local.dashboard_permissions
    content {
      principal = permissions.value.principal
      actions   = permissions.value.actions
    }
  }
}
