terraform {
  source = "${dirname(find_in_parent_folders())}/modules/security_group/ver_2.0.0"
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

// elasticache subnet group은 name 값이 변경되면 재생성 됩니다.

inputs = {
  security_group = [
    {
      name  = "rnd-sg-1"
      vpc   = dependency.vpc.outputs.vpc_id["rnd-vpc-1"]["vpc_id"]
      ingress_rules = {
        1 = {
          rule_name   = "basic-inbound-vpn1"
          cidr_blocks = "62.74.61.204/32"
          protocol    = "tcp"
          port_range   = ["24-27"]
        },
        2 = {
          rule_name   = "basic-inbound-vpn2"
          cidr_blocks = "62.74.61.204/32"
          protocol    = "tcp"
          port_range   = ["40-41"]
        },
      }
      egress_rules = {
        1 = {
          rule_name   = "basic-outboud-01"
          cidr_blocks = "0.0.0.0/0"
          protocol    = "tcp"
          port_range   = ["22-23"]
        },
      }

    },

  ]
}


