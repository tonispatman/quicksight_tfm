output "dashboard_arn" {
  value = aws_quicksight_dashboard.from_imported_template.arn
}
output "dashboard_console_url" {
  value = "https://${var.region}.quicksight.aws.amazon.com/sn/dashboards/${var.dashboard_id}"
}
