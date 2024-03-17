terraform {
  source = "${dirname(find_in_parent_folders())}/modules/iam_custom_role/ver_1.0.0"
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

// iam_role은 name 값이 변경되면 재생성 됩니다.


inputs = {
  iam_role = [
    {
      name    = "@owner"
      attach_policy = [
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "AdministratorAccess", "arn:aws:iam::aws:policy/AdministratorAccess")
      ] # null (or) policy name
      assume_role_policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::552793652587:user/limsm"
            },
            "Action": "sts:AssumeRole"
          }
        ]
      })
    },
    {
      name    = "@admin"
      attach_policy = [ 
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "IAMFullAccess", "arn:aws:iam::aws:policy/IAMFullAccess"),
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "AmazonVPCFullAccess", "arn:aws:iam::aws:policy/AmazonVPCFullAccess"),
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess"),
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "AmazonS3FullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"),
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "AWSCertificateManagerFullAccess", "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess")
      ] # null (or) policy name
      assume_role_policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "AWS": [
                "arn:aws:iam::552793652587:user/sdxx365",
                "arn:aws:iam::552793652587:user/ihanni",
                "arn:aws:iam::552793652587:user/ity0104"
              ]
            },
            "Action": "sts:AssumeRole"
          }
        ]
      })
    },
    {
      name    = "@SE"
      attach_policy = [
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "IAMFullAccess", "arn:aws:iam::aws:policy/IAMFullAccess")
      ] # null (or) policy name
      assume_role_policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "AWS": [
                "arn:aws:iam::552793652587:user/junwan",
                "arn:aws:iam::552793652587:user/ygs1340"
              ]
            },
            "Action": "sts:AssumeRole"
          }
        ]
      })
    },
    {
      name    = "@DBA"
      attach_policy = [] # null (or) policy name
      assume_role_policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "AWS": [
                "arn:aws:iam::552793652587:user/miracle2368",
                "arn:aws:iam::552793652587:user/chuy9999",
                "arn:aws:iam::552793652587:user/pydj2119"
              ]
            },
            "Action": "sts:AssumeRole"
          }
        ]
      })
    },
    {
      name    = "EC2_ReadOnly"
      attach_policy = [
        lookup(dependency.iam_custom_policy.outputs.policy_arn, "AmazonEC2ReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess")
      ] # null (or) policy name
      assume_role_policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "sts:AssumeRole"
            ],
            "Principal": {
              "Service": [
                  "ec2.amazonaws.com"
              ]
            }
          }
        ]
      })
    },





  ]

  
}


