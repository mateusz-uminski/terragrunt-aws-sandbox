include "root" {
  path = find_in_parent_folders("main.hcl")
}

dependencies {
  paths = [
    "${get_path_to_repo_root()}/microcloud-sandbox/eu-west-1/.settings/vpc",
  ]
}

dependency "main_vpc_ew1_sandbox" {
  config_path = "${get_path_to_repo_root()}/microcloud-sandbox/eu-west-1/.settings/vpc"

  mock_outputs = {
    vpc_id = ""
  }
}

inputs = {
  vpcs = {
    "main_vpc_ew1_sandbox" = {
      "vpc_id" = dependency.main_vpc_ew1_sandbox.outputs.vpc_id
      "region" = "eu-west-1"
    },
  }
}
