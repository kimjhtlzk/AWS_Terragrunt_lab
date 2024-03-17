terraform {
  source = "${dirname(find_in_parent_folders())}/modules/iam_user/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}

dependency "iam_custom_policy" {
  config_path = find_in_parent_folders("iam_custom_policy")
  mock_outputs = {
    # subnets_ids = ["subnetids-EXAMPLE"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

// iam_user은 name 값이 변경되면 재생성 됩니다.

inputs = {
  iam_user = [
    {
      name    = "ihanni-rnd-user-1"
      policy = [
                  lookup(dependency.iam_custom_policy.outputs.policy_arn, "InfraC-Office", "arn:aws:iam::aws:policy/InfraC-Office"),
                  lookup(dependency.iam_custom_policy.outputs.policy_arn, "AdministratorAccess", "arn:aws:iam::aws:policy/AdministratorAccess"),
                ]
    },
    {
      name    = "ihanni-rnd-user-2"
      policy = [
                  lookup(dependency.iam_custom_policy.outputs.policy_arn, "InfraC-Office", "arn:aws:iam::aws:policy/InfraC-Office"),
                ]
    },
  ]
}

