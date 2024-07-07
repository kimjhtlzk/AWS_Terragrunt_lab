variable "security_group" {
  type = list(object({
    name  = string
    vpc   = string
    ingress_rules = map(object({
      rule_name   = string
      cidr_blocks = string
      protocol    = string
      port_range  = list(string)
    }))
    egress_rules = map(object({
      rule_name   = string
      cidr_blocks = string
      protocol    = string
      port_range  = list(string)
    }))
  }))
}
