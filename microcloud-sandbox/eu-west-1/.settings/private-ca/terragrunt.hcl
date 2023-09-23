include "root" {
  path = find_in_parent_folders("main.hcl")
}

dependencies {
  paths = [
    "${get_path_to_repo_root()}/microcloud-sandbox/.settings/private-ca",
  ]
}

dependency "sandbox_ca" {
  config_path = "${get_path_to_repo_root()}/microcloud-sandbox/.settings/private-ca"

  mock_outputs = {
    sandbox_corp_private_ca = ""
    sandbox_vpn_private_ca  = ""
  }
}

inputs = {
  sandbox_corp_private_ca = dependency.sandbox_ca.outputs.sandbox_corp_private_ca
  sandbox_vpn_private_ca  = dependency.sandbox_ca.outputs.sandbox_vpn_private_ca
}
