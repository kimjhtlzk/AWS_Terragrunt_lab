terraform {
  source = "${dirname(find_in_parent_folders())}/modules/ec2_instance/ver_1.0.0"
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
dependency "elastic_ip" {
  config_path = find_in_parent_folders("elastic_ip")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
dependency "security_group" {
  config_path = find_in_parent_folders("security_group")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
dependency "ebs" {
  config_path = find_in_parent_folders("ebs")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
dependency "instance_profile" {
  config_path = find_in_parent_folders("instance_profile")
  mock_outputs = {
    # vpc_id = "vpc-EXAMPLE"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


inputs = {
  ec2_instance = [
    {
      name                        = "rnd-ec2-1"
      ami                         = "ami-097bf0ec147165215"
      instance_type               = "t2.small"
      availability_zone           = "${local.aws_region}a"

      subnet                      = dependency.vpc.outputs.subnets_ids["rnd-vpc-1-subnet-1"]
      private_ip                  = "10.11.11.11"
      associate_public_ip_address = dependency.elastic_ip.outputs.eip_id["rnd-eip-2"] # null or eip name
      security_groups             = [ 
                                      dependency.security_group.outputs.security_group_ids["rnd-sg-1"]
                                    ] # if no security_groups = []

      spot_options = { # It only works when "use_spot" is true.
        use_spot                        = false
        instance_interruption_behavior  = "terminate" # "hibernate", "stop", "terminate"
        spot_instance_type              = "one-time" # "one-time", "persistent"
        max_price                       = 0.05 # minimum required Spot request fulfillment price of 0.0375.
      }

      root_ebs = {
        root_ebs_type = "gp3" # EBS 볼륨 유형 ([ssd]gp2, gp3 / [hdd] st1, standard)
        root_ebs_size = 50
        delete_on_termination = true
      }

      add_ebs = {
        1 = {
          add_ebs_type  = "gp3" # EBS 볼륨 유형 ([ssd]gp2, gp3 / [hdd] st1, standard)
          add_ebs_size  = 50
          add_ebs_path  = "/dev/xvdb"  # 마운트할 디바이스 이름
          iops          = 5000  # Only valid for type of io1, io2 or gp3. basic value = 3000
          throughput    = 200 # Only valid for type of gp3. basic value = 125
          snapshot_id   = null
          ebs_id        = null # 별도의 ebs를 따로 만들어 붙일 때만 사용합니다.
        }
        # 2 = {
        #   add_ebs_type  = "gp3" # EBS 볼륨 유형 ([ssd]gp2, gp3 / [hdd] st1, standard)
        #   add_ebs_size  = 50
        #   add_ebs_path  = "/dev/xvdc"  # 마운트할 디바이스 이름
        #   iops          = 5000  # Only valid for type of io1, io2 or gp3. basic value = 3000
        #   throughput    = 200 # Only valid for type of gp3. basic value = 125
        #   snapshot_id   = null
        #   ebs_id        = dependency.ebs.outputs.ebs_id["rnd-ebs-1"] # 별도의 ebs를 따로 만들어 붙일 때만 사용합니다.
        # }
        
      }

      iam_instance_profile    = "pf-ec2-readonly"  # null (or) instance profile name
      disable_api_termination = false  # 종료방지 / spot 사용시 false만 사용가능
    },



  ]
}


