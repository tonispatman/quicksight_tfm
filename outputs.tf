output "template_id" { value = aws_quicksight_template.from_analysis.template_id }
output "template_arn" { value = aws_quicksight_template.from_analysis.arn }

output "dashboard_ids" {
  value = { for k, d in aws_quicksight_dashboard.from_template : k => d.dashboard_id }
}

output "dashboard_arns" {
  value = { for k, d in aws_quicksight_dashboard.from_template : k => d.arn }
}
