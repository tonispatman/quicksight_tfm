locals {
  analysis_arn      = "arn:aws:quicksight:${var.region}:${var.account_id}:analysis/${var.analysis_id}"
  dataset_arn       = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
  template_arn      = "arn:aws:quicksight:${var.region}:${var.account_id}:template/${var.template_id}"
  readers_group_arn = var.readers_group_name == null ? null : "arn:aws:quicksight:${var.region}:${var.account_id}:group/default/${var.readers_group_name}"
}
