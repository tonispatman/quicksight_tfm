output "template_id" { value = aws_quicksight_template.from_analysis.template_id }
output "template_arn" { value = aws_quicksight_template.from_analysis.arn }
output "dashboard_id" { value = aws_quicksight_dashboard.from_template.dashboard_id }
output "dashboard_arn" { value = aws_quicksight_dashboard.from_template.arn }
