locals {
  org      = var.org_abbreviated_name
  vpc_name = "main"
  vpn_cidr = "172.18.0.0./16"
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

module "ec2" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//ec2?ref=ec2/v0.3.0"

  # required variables
  org_abbreviated_name = local.org
  project              = "infra"
  environment          = "poc"

  instance_name    = "centos"
  instance_type    = "t2.micro"
  ami_name_pattern = "CentOS-Stream-ec2-9-*"
  key_pair         = "${local.org}-main-key-pair-sandbox"

  vpc_name    = "${local.org}-${local.vpc_name}-vpc-sandbox"
  subnet_name = "${local.org}-${local.vpc_name}-public-sn1-sandbox"

  # optional variables
  assign_public_ip           = true
  instance_profile_name      = ""
  enable_detailed_monitoring = false

  root_ebs_size  = 0
  additional_ebs = {}
  # additional_ebs = {
  #   "ebs1" = {
  #     size        = 20
  #     device_name = "/dev/sdb"
  #     type        = "gp2"
  #   },
  #   "ebs2" = {
  #     size        = 20
  #     device_name = "/dev/sdc"
  #     type        = "gp2"
  #   },
  # }

  user_data = <<-EOF
    #! /bin/bash
    touch /helloworld.txt
  EOF

  allowed_ingress_cidrs = ["${chomp(data.http.my_ip.response_body)}/32", local.vpn_cidr]
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_private_ip" {
  value = module.ec2.private_ip
}
