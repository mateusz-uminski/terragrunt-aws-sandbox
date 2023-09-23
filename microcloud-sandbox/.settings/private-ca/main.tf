locals {
  organization_name = "microcloud"
}

module "sandbox_corp_private_ca" {
  source = "git::https://github.com/mateusz-uminski/terraform-service-modules//tls-private-ca?ref=tls-private-ca/v0.1.1"

  # required variables
  organization_name = local.organization_name
  domain_name       = "sandbox.corp.microcloud.com"

  # optional variables
  save_to_pem_files = true
}

module "sandbox_vpn_private_ca" {
  source = "git::https://github.com/mateusz-uminski/terraform-service-modules//tls-private-ca?ref=tls-private-ca/v0.1.1"

  # required variables
  organization_name = local.organization_name
  domain_name       = "sandbox.vpn.microcloud.com"

  # optional variables
  save_to_pem_files = true
}

output "sandbox_corp_private_ca" {
  value = {
    key  = module.sandbox_corp_private_ca.private_key_pem
    cert = module.sandbox_corp_private_ca.cert_pem
  }
  sensitive = true
}

output "sandbox_vpn_private_ca" {
  value = {
    key  = module.sandbox_vpn_private_ca.private_key_pem
    cert = module.sandbox_vpn_private_ca.cert_pem
  }
  sensitive = true
}
