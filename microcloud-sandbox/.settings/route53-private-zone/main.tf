variable "vpcs" {
  type = map(object({
    vpc_id = string
    region = string
  }))
  description = "Defined in the terragrunt.hcl file."
}

locals {
  hosted_zone_name = "ew1.sandbox.corp.microcloud.com"
}

module "ew1_sandbox_corp_microcloud_com" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//route53-private-zone?ref=route53-private-zone/v0.1.0"

  # required variables
  zone_name = local.hosted_zone_name
  vpcs      = var.vpcs

  # optional variables
  external_vpcs = {}
}

output "ew1_sandbox_corp_microcloud_com_zone_id" {
  value = module.ew1_sandbox_corp_microcloud_com.zone_id
}

resource "aws_route53_record" "example" {
  zone_id = module.ew1_sandbox_corp_microcloud_com.zone_id

  name    = "example.${local.hosted_zone_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["example"]
}
