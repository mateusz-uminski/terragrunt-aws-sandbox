locals {
  org      = var.org_abbreviated_name
  vpc_name = "main"
  vpn_cidr = "172.18.0.0/16"
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

module "asg" {
  source = "git::https://github.com/mateusz-uminski/terraform-aws-modules//asg?ref=feat/asg"

  # required variables
  org_abbreviated_name = local.org
  project              = "infra"
  environment          = "poc"

  asg_name     = "centos"
  asg_capacity = 3

  instance_type    = "t2.micro"
  ami_name_pattern = "CentOS-Stream-ec2-9-*"
  key_pair         = "${local.org}-main-key-pair-sandbox"

  vpc_name     = "${local.org}-${local.vpc_name}-vpc-sandbox"
  subnet_names = ["${local.org}-${local.vpc_name}-public-sn1-sandbox", "${local.org}-${local.vpc_name}-public-sn2-sandbox"]

  # optional variables
  placement_group            = "partition"
  assign_public_ip           = true
  instance_profile_name      = ""
  enable_detailed_monitoring = false

  root_ebs = {
    device_name = "/dev/sda1"
    size        = 20
  }

  additional_ebs = {
    "ebs1" = {
      size        = 20
      device_name = "/dev/sdb"
      type        = "gp2"
    }
  }

  user_data = <<-EOF
    #! /bin/bash
    touch /helloworld.txt
  EOF

  additional_security_groups = []
  allowed_ingress_cidrs      = ["${chomp(data.http.my_ip.response_body)}/32", local.vpn_cidr]
  allowed_ingress_sgs        = []

  exposed_port = 80
  protocol     = "HTTP"
}

output "name" {
  value = module.asg.target_group_arn
}
