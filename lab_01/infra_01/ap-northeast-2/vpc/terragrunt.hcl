terraform {
  # source = "/Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/module/vpc/ver_1.0.0"
  source = "${dirname(find_in_parent_folders())}/modules/vpc/ver_1.0.0"
  
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}

// vpc는 cidr_block 값이 변경되면 재생성 됩니다.
// subnet은 subnet_cidr 와 availability_zone의 값이 변동되면 재생성 됩니다.
// ipv6를 사용하기 위하여 vpc의 use_ipv6_cidr_block의 값을 true로 생성 시, subnets 의 ipv6_cidr_block 값은 null 값으로 유지한 상태로 실행합니다.
// -> 이후 vpc의 ipv6_cidr_block 리소스가 생성되면 그 값을 그대로 사용하거나
//    적절하게 Subnetting하여 subnets 의 ipv6_cidr_block에 작성 후 실행합니다.
//    ipam 방식 미사용.

inputs = {
  vpcs = [
    {
      name                = "rnd-vpc-1"
      cidr_block          = "10.11.0.0/16"
      use_ipv6_cidr_block = true
      subnets = [
        {
          subnet_name       = "rnd-vpc-1-subnet-1"
          subnet_cidr       = "10.11.11.0/24"
          ipv6_cidr_block   = null # ipv6 cidr (or) null
          availability_zone = "${local.aws_region}a"
          autoassign_public = true
          tags = {
            "kubernetes.io/role/internal-eld" = "1"
          }
        },
        {
          subnet_name       = "rnd-vpc-1-subnet-2"
          subnet_cidr       = "10.11.12.0/24"
          ipv6_cidr_block   = null
          availability_zone = "${local.aws_region}b"
          autoassign_public = false
          tags = {
            "kubernetes.io/role/internal-eld" = "2"
          }
        },
      ]
    },
    {
      name                = "rnd-vpc-2"
      cidr_block          = "10.13.0.0/16"
      use_ipv6_cidr_block = false
      subnets = [
        {
          subnet_name       = "rnd-vpc-2-subnet-2"
          subnet_cidr       = "10.13.11.0/24"
          ipv6_cidr_block   = null  # ipv6 cidr (or) null
          availability_zone = "${local.aws_region}a"
          autoassign_public = "true"
          tags = {
            "kubernetes.io/role/internal-eld" = "1"
          }
        },
      ]
    },
  ]
}


