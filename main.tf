# 1) Template from existing Analysis
resource "aws_quicksight_template" "from_analysis" {
  aws_account_id      = var.account_id
  template_id         = var.template_id
  name                = var.template_name
  version_description = var.template_version_description

  source_entity {
    source_analysis {
      arn = "arn:aws:quicksight:${var.region}:${var.account_id}:analysis/${var.analysis_id}"
      data_set_references {
        data_set_placeholder = var.dataset_placeholder
        data_set_arn         = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
      }
    }
  }
}

# 2) Dashboard from the Template (existing)
resource "aws_quicksight_dashboard" "from_template" {
  aws_account_id      = var.account_id
  dashboard_id        = var.dashboard_id
  name                = var.dashboard_name
  version_description = var.dashboard_version_description

  source_entity {
    source_template {
      arn = aws_quicksight_template.from_analysis.arn
      data_set_references {
        data_set_placeholder = var.dataset_placeholder
        data_set_arn         = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
      }
    }
  }

  # keep only your user permission
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

# 3) Second dashboard from the same template
resource "aws_quicksight_dashboard" "from_template_v2" {
  aws_account_id      = var.account_id
  dashboard_id        = "saas-sales-dash-tf-2"
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

  # keep only your user permission
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

# 4) Second dashboard from the same template
resource "aws_quicksight_dashboard" "from_template_v2" {
  aws_account_id      = var.account_id
  dashboard_id        = "saas-sales-dash-for-client-2"
  name                = "SaaS Sales Dashboard for Client 2"
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

  # keep only your user permission
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
