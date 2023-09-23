locals {
  config_vars = yamldecode(file(find_in_parent_folders("config.yaml")))

  account_name = "mcd-sandbox"
  account_id   = local.config_vars.mcd_account_id_sandbox
  aws_profile  = "mcd-cloudadmin-sandbox"
}
