terraform {
  source = "${dirname(find_in_parent_folders())}/modules/internet_gateway/ver_1.0.0"
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

// igw는 name값이 변경되면 재생성 됩니다.


inputs = {
  igw = [
    {
      name    = "igw-rnd-vpc-1"
      vpc     = dependency.vpc.outputs.vpc_id["rnd-vpc-1"]["vpc_id"]
    },
    {
      name    = "igw-rnd-vpc-2"
      vpc     = null
    },
  ]
}
