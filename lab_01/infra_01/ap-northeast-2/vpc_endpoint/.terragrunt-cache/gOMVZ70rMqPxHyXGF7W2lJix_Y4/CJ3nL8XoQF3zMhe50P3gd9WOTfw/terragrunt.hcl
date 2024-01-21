terraform {
  source = "/Users/hann/hann_labs/terrform_labs/terragrunt_labs/lab_01/module/vpc/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

            
locals {
  eps = [
    {
      name    = "endpoint-rnd-vpc-1"
      vpc     = "rnd-vpc-1"
      region  = "ap-northeast-2"
    },
    {
      name    = "endpoint-rnd-vpc-2"
      vpc     = "rnd-vpc-2"
      region  = "ap-northeast-2"
    },
  ]
}

inputs = {
  eps = local.eps
}


