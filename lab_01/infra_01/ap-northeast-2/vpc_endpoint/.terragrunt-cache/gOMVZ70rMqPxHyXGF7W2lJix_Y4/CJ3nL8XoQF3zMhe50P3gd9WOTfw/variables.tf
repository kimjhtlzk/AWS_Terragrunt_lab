variable "vpcs" {
  type = list(object({
    name = string
    cidr_block = string
    instance_tenancy = string
    use_ipv6_cidr_block = bool
    subnets = list(object({
      subnet_name         = string
      subnet_cidr         = string
      ipv6_cidr_block   = string
      availability_zone   = string
      autoassign_public   = string
      tags = object({
      })
    }))
  }))
}

