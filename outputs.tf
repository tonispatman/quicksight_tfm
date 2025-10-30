output "dashboard_arn" {
  value = aws_quicksight_dashboard.poc_from_imported_template.arn
}

output "dashboard_console_url" {
  value = "https://${var.region}.quicksight.aws.amazon.com/sn/dashboards/${var.dashboard_id}"
}
