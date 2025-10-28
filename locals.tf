locals {
  analysis_arn    = "arn:aws:quicksight:${var.region}:${var.account_id}:analysis/${var.analysis_id}"
  owner_principal = "arn:aws:quicksight:${var.region}:${var.account_id}:user/default/${var.owner_user_name}"

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

  # Minimal viewer actions for a Readers group (optional)
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
