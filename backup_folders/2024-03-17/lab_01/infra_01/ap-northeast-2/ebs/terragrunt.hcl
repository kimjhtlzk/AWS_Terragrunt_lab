terraform {
  source = "/Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/module/ebs/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}


inputs = {
  ebs = [
    # {
    #   name              = "rnd-ebs-1"
    #   availability_zone = "${local.aws_region}a"
    #   type              = "gp3"   # standard, gp2, gp3, io1, io2
    #   size              = 40
    #   # If specified as null, the default value is used, or no value is used.
    #   snapshot_id       = null
    #   iops              = null    # only io1 io2, gp3
    #   throughput        = null    # only gp3
    #   device_name       = null    # null or ex) "/dev/sdh"
    # },



  ]
}


