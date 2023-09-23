locals {
  organization_name = "microcloud"
}

variable "sandbox_corp_private_ca" {
  type = object({
    key  = string
    cert = string
  })
  description = "Defined in the terragrunt.hcl file."
}

variable "sandbox_vpn_private_ca" {
  type = object({
    key  = string
    cert = string
  })
  description = "Defined in the terragrunt.hcl file."
}


module "ew1_sandbox_corp_private_ca" {
  source = "git::https://github.com/mateusz-uminski/terraform-service-modules//tls-certificate?ref=tls-certificate/v0.1.0"

  # required variables
  organization_name = "microcloud"
  domain_name       = "ew1.sandbox.corp.microcloud.com"

  # optional variables
  key_size = 2048

  is_intermediate_ca = true
  ca_private_key_pem = var.sandbox_corp_private_ca.key
  ca_cert_pem        = var.sandbox_corp_private_ca.cert
  ca_cert_chain_pem  = var.sandbox_corp_private_ca.cert

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
    "client_auth",
  ]

  save_to_pem_files = true
}

module "ew1_sandbox_vpn_private_ca" {
  source = "git::https://github.com/mateusz-uminski/terraform-service-modules//tls-certificate?ref=tls-certificate/v0.1.0"

  # required variables
  organization_name = "microcloud"
  domain_name       = "ew1.sandbox.vpn.microcloud.com"

  # optional variables
  key_size = 2048

  is_intermediate_ca = true
  ca_private_key_pem = var.sandbox_vpn_private_ca.key
  ca_cert_pem        = var.sandbox_vpn_private_ca.cert
  ca_cert_chain_pem  = var.sandbox_vpn_private_ca.cert

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
    "client_auth",
  ]

  save_to_pem_files = true
}

output "ew1_sandbox_corp_private_ca" {
  value = {
    key   = module.ew1_sandbox_corp_private_ca.private_key_pem
    cert  = module.ew1_sandbox_corp_private_ca.locally_signed_cert_pem
    chain = module.ew1_sandbox_corp_private_ca.chain_pem
  }
  sensitive = true
}

output "ew1_sandbox_vpn_private_ca" {
  value = {
    key   = module.ew1_sandbox_vpn_private_ca.private_key_pem
    cert  = module.ew1_sandbox_vpn_private_ca.locally_signed_cert_pem
    chain = module.ew1_sandbox_vpn_private_ca.chain_pem
  }
  sensitive = true
}
