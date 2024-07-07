locals {
  # account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # account_name = local.account_vars.locals.account_name
  # account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}

remote_state {
    backend = "local"
    generate = {
        path        = "backend.tf"
        if_exists   = "overwrite_terragrunt"
    }

    config = {
        path    = "${path_relative_to_include()}/terraform.tfstate"
    }
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

inputs = merge(
  # local.account_vars.locals,
  local.region_vars.locals,
  # local.environment_vars.locals,
)