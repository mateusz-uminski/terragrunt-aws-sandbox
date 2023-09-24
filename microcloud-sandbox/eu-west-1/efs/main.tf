locals {
  org      = var.org_abbreviated_name
  vpc_name = "main"
  vpc_tier = "sandbox"
}

module "efs" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//efs?ref=efs/v0.1.0"

  # required variables
  org_abbreviated_name = local.org
  project              = "infra"
  environment          = "poc"

  efs_name = "example"
  vpc_name = "${local.org}-${local.vpc_name}-vpc-${local.vpc_tier}"

  subnet_names = [
    "${local.org}-${local.vpc_name}-public-sn1-${local.vpc_tier}",
    "${local.org}-${local.vpc_name}-public-sn2-${local.vpc_tier}",
  ]

  # optional variables
  access_point_dir = {
    path        = ""
    owner       = 1000
    group       = 1000
    permissions = "444"
  }

  access_point_user = {
    uid      = 1000
    group_id = 1000
  }

  additional_security_groups = []
  allowed_ingress_cidrs      = []
  allowed_ingress_sgs        = []
}

output "efs_id" {
  value = module.efs.efs_id
}

output "efs_dns_name" {
  value = module.efs.efs_dns_name
}
