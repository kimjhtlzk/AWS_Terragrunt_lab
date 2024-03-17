terraform {
  source = "${dirname(find_in_parent_folders())}/modules/elasticache_subnet_group/ver_1.0.0"
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
    # subnets_ids = ["subnetids-EXAMPLE"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

// elasticache subnet group은 name 값이 변경되면 재생성 됩니다.

inputs = {
  elasticache_subnet_group = [
    {
      name    = "rnd-subnetgroup-1"
      subnets = [
                  dependency.vpc.outputs.subnets_ids["rnd-vpc-1-subnet-1"],
                  dependency.vpc.outputs.subnets_ids["rnd-vpc-1-subnet-2"],
                ]
    },
    {
      name    = "rnd-subnetgroup-2"
      subnets = [
                  dependency.vpc.outputs.subnets_ids["rnd-vpc-2-subnet-2"],
                ]
    },
  ]
}


