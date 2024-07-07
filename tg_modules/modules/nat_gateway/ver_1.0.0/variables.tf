variable "ngw" {
  type = list(object({
    name        = string
    eip         = string
    subnets     = string
    private_ip  = string
  }))
}
