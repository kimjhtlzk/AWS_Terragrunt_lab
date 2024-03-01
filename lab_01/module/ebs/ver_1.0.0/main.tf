resource "aws_ebs_volume" "ebs_volume" {
  for_each = { for ebs in var.ebs : ebs.name => ebs }

  tags = {
    Name = each.value.name
  }

  availability_zone = each.value.availability_zone
  type              = each.value.type
  size              = each.value.size

  snapshot_id = each.value.snapshot_id != null ? each.value.snapshot_id : null
  iops        = each.value.iops != null ? each.value.iops : null
  throughput  = each.value.throughput != null ? each.value.throughput : null
}

