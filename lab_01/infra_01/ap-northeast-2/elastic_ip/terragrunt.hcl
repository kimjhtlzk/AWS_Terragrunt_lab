terraform {
  source = "${dirname(find_in_parent_folders())}/modules/elastic_ip/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}


inputs = {
  eip = [
    {
      name  = "rnd-eip-1"
    },
    {
      name  = "rnd-eip-2"
    },


  ]
}


