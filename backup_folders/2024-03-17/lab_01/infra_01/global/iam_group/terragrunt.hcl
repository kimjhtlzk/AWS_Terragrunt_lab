terraform {
  source = "/Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/module/iam_group/ver_1.0.0"
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
dependency "iam_user" {
  config_path = find_in_parent_folders("iam_user")
  mock_outputs = {
    # mock any necessary outputs here
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
// iam_group name 값이 변경되면 재생성 됩니다.

inputs = {
  iam_group = [
    {
      name    = "Infra-Common"
      policy = [
                  lookup(dependency.iam_custom_policy.outputs.policy_arn, "InfraC-Office", "arn:aws:iam::aws:policy/InfraC-Office"),
                  lookup(dependency.iam_custom_policy.outputs.policy_arn, "AdministratorAccess", "arn:aws:iam::aws:policy/AdministratorAccess"),
                ]
      users = [
                "ihanni-rnd-user-1",
                "ihanni-rnd-user-2"
              ]
    },
    {
      name    = "Infra-Admin"
      policy = [
                  lookup(dependency.iam_custom_policy.outputs.policy_arn, "IAMFullAccess", "arn:aws:iam::aws:policy/IAMFullAccess"),
                ]
      users = [
              ]
    },
  ]
}

