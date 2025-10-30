locals {
  # Option B from earlier (suffix style)
  template_alias_suffix = var.template_alias_name == null ? "" : "/alias/${var.template_alias_name}"
  template_arn          = "arn:aws:quicksight:${var.region}:${var.account_id}:template/${var.template_id}${local.template_alias_suffix}"

  dataset_arn    = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
  owner_user_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:user/default/${var.owner_user_name}"
}
