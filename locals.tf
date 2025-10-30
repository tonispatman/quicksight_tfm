locals {
  template_base_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:template/${var.template_id}"
  template_arn      = var.template_alias_name != null
                    ? "${local.template_base_arn}/alias/${var.template_alias_name}"
                    : local.template_base_arn

  dataset_arn    = "arn:aws:quicksight:${var.region}:${var.account_id}:dataset/${var.dataset_id}"
  owner_user_arn = "arn:aws:quicksight:${var.region}:${var.account_id}:user/default/${var.owner_user_name}"
}
