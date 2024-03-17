locals {
  ec2_add_ebs = flatten([
    for ec2_instance in var.ec2_instance : [
      for add_ebs_key, add_ebs_value in ec2_instance.add_ebs : {
        name = ec2_instance.name
        availability_zone = ec2_instance.availability_zone
        add_ebs_path = add_ebs_value.add_ebs_path
        ebs_id = add_ebs_value.ebs_id != null ? add_ebs_value.ebs_id : add_ebs_value.snapshot_id
        ebs_key = add_ebs_key
        ebs_value = add_ebs_value
      }
    ]
  ])
}

resource "aws_instance" "ec2" {
    for_each = { for ec2_instance in var.ec2_instance : ec2_instance.name => ec2_instance }

    tags = {
        Name = each.value.name
    }
    ami                     = each.value.ami
    instance_type           = each.value.instance_type
    availability_zone       = each.value.availability_zone
    iam_instance_profile    = each.value.iam_instance_profile
    
    network_interface {
        network_interface_id = aws_network_interface.nic[each.key].id
        device_index         = 0
    }

    root_block_device {
        tags = {
            Name = each.value.name
        }
        volume_type           = each.value.root_ebs.root_ebs_type
        volume_size           = each.value.root_ebs.root_ebs_size
        delete_on_termination = each.value.root_ebs.delete_on_termination
        encrypted             = false
    }

    maintenance_options {
        auto_recovery = "default"
    }

    hibernation             = false # 절전모드
    disable_api_stop        = false # 중지방지
    disable_api_termination = each.value.disable_api_termination  # 종료방지

    dynamic "instance_market_options" {
        for_each = each.value.spot_options.use_spot == true ? [1] : []
        content {
            market_type = "spot"
            spot_options {
                instance_interruption_behavior  = each.value.spot_options.instance_interruption_behavior
                spot_instance_type              = each.value.spot_options.spot_instance_type
                max_price                       = each.value.spot_options.max_price
            }
        }
    }

    # user_data 변경이 일어날시 서버는 재부팅된다. (stop 과정이 필요)
    user_data = null

}

# -----------------------------------------------------------------------

resource "aws_network_interface" "nic" {
    for_each = { for ec2_instance in var.ec2_instance : ec2_instance.name => ec2_instance }

    tags = {
        Name = "nic-${each.value.name}"
    }
    subnet_id       = each.value.subnet
    private_ips     = [each.value.private_ip]
    security_groups = each.value.security_groups != null ? each.value.security_groups : null
}

resource "aws_eip_association" "eip_att" {
  for_each = {
    for idx, ec2_instance in var.ec2_instance : idx => ec2_instance
    if ec2_instance.associate_public_ip_address != null
  }

  network_interface_id = aws_network_interface.nic[each.value.name].id
  allocation_id        = each.value.associate_public_ip_address
}



# -----------------------------------------------------------------------

resource "aws_ebs_volume" "ebs" {
  for_each = { 
    for ebs in local.ec2_add_ebs : "${ebs.name}-${ebs.ebs_key}" => ebs 
    if ebs.ebs_id == null
  }

  tags = {
    Name = "${each.key}"
  }

  availability_zone = each.value.availability_zone
  size              = each.value.ebs_value.add_ebs_size
  type              = each.value.ebs_value.add_ebs_type
  iops              = each.value.ebs_value.iops
  throughput        = each.value.ebs_value.throughput
  snapshot_id       = each.value.ebs_id
}

resource "aws_volume_attachment" "ebs_att" {
    for_each = { for ebs in local.ec2_add_ebs : "${ebs.name}-${ebs.ebs_key}" => ebs }

    device_name = each.value.add_ebs_path
    volume_id   = each.value.ebs_id != null ? each.value.ebs_id : aws_ebs_volume.ebs[each.key].id
    instance_id = aws_instance.ec2[each.value.name].id
}
