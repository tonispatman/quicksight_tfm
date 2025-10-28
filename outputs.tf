output "template_id" { value = aws_quicksight_template.from_analysis.template_id }
output "template_arn" { value = aws_quicksight_template.from_analysis.arn }

output "dashboard_ids" {
  description = "Map of dashboard ids by logical name"
  value       = { for k, d in aws_quicksight_dashboard.from_template : k => d.dashboard_id }
}

output "dashboard_arns" {
  description = "Map of dashboard ARNs by logical name"
  value       = { for k, d in aws_quicksight_dashboard.from_template : k => d.arn }
}
