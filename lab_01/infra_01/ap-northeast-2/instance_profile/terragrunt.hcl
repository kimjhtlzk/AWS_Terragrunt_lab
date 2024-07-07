terraform {
  source = "${dirname(find_in_parent_folders())}/modules/instance_profile/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}

dependency "iam_custom_role" {
  config_path = find_in_parent_folders("../global/iam_custom_role")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


inputs = {
  instance_profile = [
    # {
    #   name  = "pf-ec2-readonly"
    #   role  = "EC2_ReadOnly"
    # },


  ]
}
