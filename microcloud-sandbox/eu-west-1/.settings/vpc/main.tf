locals {
  org = var.org_abbreviated_name
}

module "vpc" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//vpc?ref=vpc/v0.5.2"

  # required variables
  org_abbreviated_name = local.org
  vpc_name             = "main"
  vpc_tier             = "sandbox"
  vpc_cidr             = "10.36.0.0/16"

  public_subnets  = ["10.36.0.0/20", "10.36.16.0/20"]
  private_subnets = []
  storage_subnets = []

  # optional variables
  domain_name                 = "ew1.sandbox.corp.microcloud.com"
  vpc_flow_logs_s3_bucket_arn = ""
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
