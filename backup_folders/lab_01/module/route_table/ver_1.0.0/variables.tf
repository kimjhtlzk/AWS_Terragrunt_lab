variable "route_table" {
  type = list(object({
    name    = string
    vpc     = string
    subnets = list(string)
    rule    = map(object({
        cidr_block      = string
        resource_type   = string
        resource_name   = string
    }))
  }))
}
