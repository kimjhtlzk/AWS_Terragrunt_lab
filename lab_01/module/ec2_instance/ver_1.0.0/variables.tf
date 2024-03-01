variable "ec2_instance" {
  type = list(object({
    name                        = string
    ami                         = string
    instance_type               = string
    availability_zone           = string
    # vpc                         = string
    subnet                      = string
    private_ip                  = string
    associate_public_ip_address = string
    security_groups             = list(string)
    spot_options  = object({
      use_spot                        = bool
      instance_interruption_behavior  = string
      spot_instance_type              = string
      max_price                       = number
    })
    root_ebs  = object({
      root_ebs_type         = string
      root_ebs_size         = number
      delete_on_termination = bool
    })
    add_ebs  = map(object({
      add_ebs_type  = string
      add_ebs_size  = number
      add_ebs_path  = string
      iops          = number
      throughput    = number
      snapshot_id   = string
      ebs_id        = string
    }))
    iam_instance_profile    = string
    disable_api_termination = bool
  }))
}
