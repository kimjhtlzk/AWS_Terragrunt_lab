terraform {
  source = "${dirname(find_in_parent_folders())}/modules/iam_custom_policy/ver_1.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.aws_region
}

// iam_policy은 name 값이 변경되면 재생성 됩니다.


inputs = {
  iam_policy = [
    {
      name    = "InfraC-Office"
      policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
              "NotIpAddress": {
                "aws:SourceIp": [
                  "220.70.82.0/24",
                  "183.111.137.68/32",
                  "218.146.3.0/24"
                ]
              },
              "Bool": {"aws:ViaAWSService": "false"}
            }
          }
        ]
      })
    },
    {
      name    = "InfraC-Office2"
      policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
              "NotIpAddress": {
                "aws:SourceIp": [
                  "220.70.82.0/24",
                  "183.111.137.68/32",
                  "218.146.3.0/24"
                ]
              },
              "Bool": {"aws:ViaAWSService": "false"}
            }
          }
        ]
      })
    },

  ]

  
}


