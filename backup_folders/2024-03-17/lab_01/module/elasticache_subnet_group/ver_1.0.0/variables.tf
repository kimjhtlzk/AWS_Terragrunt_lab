variable "elasticache_subnet_group" {
  type = list(object({
    name      = string
    subnets   = list(string)
  }))
}
