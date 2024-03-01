variable "ebs" {
  type = list(object({
    name              = string
    availability_zone = string
    type              = string
    size              = number
    snapshot_id       = string
    iops              = number
    throughput        = number
    device_name       = string
  }))
}

