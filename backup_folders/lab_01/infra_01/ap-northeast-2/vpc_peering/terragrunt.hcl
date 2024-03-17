terraform {
  source = "/Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/module/vpc_peering/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


inputs = {
  vpc_peer = [
    {
      peer_type         = "internal" # internal or external
      target_project_id = null # only external

      name          = "rnd-peer-01"
      vpc           = dependency.vpc.outputs.vpc_id["rnd-vpc-1"]["vpc_id"]
      target_vpc    = dependency.vpc.outputs.vpc_id["rnd-vpc-2"]["vpc_id"]
      other_region  = null # null or region name. if same region -> null

      accepter_dns_resolution   = true
      requester_dns_resolution  = true

    },

  ]
}


