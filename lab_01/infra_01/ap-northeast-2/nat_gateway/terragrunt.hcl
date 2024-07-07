terraform {
  source = "${dirname(find_in_parent_folders())}/modules/nat_gateway/ver_1.0.0"
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
dependency "elastic_ip" {
  config_path = find_in_parent_folders("elastic_ip")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

// ngw name값이 변경되면 재생성 됩니다.


inputs = {
  ngw = [
    {
      name        = "ngw-rnd-vpc-1"
      eip         = dependency.elastic_ip.outputs.eip_id["rnd-eip-2"]
      subnets     = dependency.vpc.outputs.subnets_ids["rnd-vpc-1-subnet-1"],    
      private_ip  = "10.11.11.250"
    },

  ]
}
