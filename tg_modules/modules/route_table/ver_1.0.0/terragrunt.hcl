terraform {
  source = "${dirname(find_in_parent_folders())}/modules/route_table/ver_1.0.0"
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
dependency "internet_gateway" {
  config_path = find_in_parent_folders("internet_gateway")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
dependency "nat_gateway" {
  config_path = find_in_parent_folders("nat_gateway")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
dependency "vpc_peering" {
  config_path = find_in_parent_folders("vpc_peering")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
// ngw name값이 변경되면 재생성 됩니다.
// igw  -> dependency.internet_gateway.outputs.igw_id["igw-rnd-vpc-1"]
// ngw  -> dependency.nat_gateway.outputs.ngw_id["ngw-rnd-vpc-1"]
// peer -> dependency.vpc_peering.outputs.vpc_peering_id["rnd-peer-01"]

inputs = {
  route_table = [
    {
      name    = "ngw-rnd-vpc-1"
      vpc     = dependency.vpc.outputs.vpc_id["rnd-vpc-1"]["vpc_id"]
      subnets = [
        dependency.vpc.outputs.subnets_ids["rnd-vpc-1-subnet-1"],
        dependency.vpc.outputs.subnets_ids["rnd-vpc-1-subnet-2"],
      ]
      rule = {
        1 ={
          cidr_block      = "0.0.0.0/0"
          resource_type   = "igw" # "igw" or "nat" or "peering"
          resource_name   = dependency.internet_gateway.outputs.igw_id["igw-rnd-vpc-1"]
        }
        2 ={
          cidr_block      = "192.168.0.0/16"
          resource_type   = "ngw" # "igw" or "nat" or "peering"
          resource_name   = dependency.nat_gateway.outputs.ngw_id["ngw-rnd-vpc-1"]
        }
      }
    },
    {
      name    = "ngw-rnd-vpc-2"
      vpc     = dependency.vpc.outputs.vpc_id["rnd-vpc-2"]["vpc_id"]
      subnets = [
        dependency.vpc.outputs.subnets_ids["rnd-vpc-2-subnet-2"],
      ]
      rule = {
        1 ={
          cidr_block      = "10.0.0.0/16"
          resource_type   = "peering" # "igw" or "nat" or "peering"
          resource_name   = dependency.vpc_peering.outputs.vpc_peering_id["rnd-peer-01"]
        }
      }
    },



  ]
}
