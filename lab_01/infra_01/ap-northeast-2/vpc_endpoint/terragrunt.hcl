terraform {
  source = "/Users/hann/hann_labs/terrform_labs/terragrunt_labs/lab_01/module/vpc_endpoint/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

// vpc_endpoint는 vpc 값이 변경되면 재생성 됩니다.
// 여러 end_point 생성 시 vpc 는 중복될 수 없습니다.
// -> 실제 기능적으로는 하나의 vpc에 여러 end_point를 생성할 수 있으나,
//    main.tf의 fore_each 식별자로 vpc 변수 값을 사용하므로,
//    다중 리소스 생성 시 식별자의 값이 중복될 수 없기 때문입니다.
//    이를 해결하기 위해 협의에 따라 main.tf의 fore_each 식별자를 name 으로 변경할 수 있습니다.
//    그럴경우 여러 end_point에 같은 vpc를 중복되게 지정하여 생성할 수 있으며,
//    name이 변경되면 식별자의 값이 변경됨으로 리소스가 재생성 됩니다.

inputs = {
  eps = [
    # {
    #   name    = "endpoint-rnd-vpc-1"
    #   vpc     = dependency.vpc.outputs.vpc_id["rnd-vpc-1"]["vpc_id"]
    #   region  = local.aws_region
    # },
    # {
    #   name    = "endpoint-rnd-vpc-2"
    #   vpc     = dependency.vpc.outputs.vpc_id["rnd-vpc-2"]["vpc_id"]
    #   region  = local.aws_region
    # },
  ]
}
