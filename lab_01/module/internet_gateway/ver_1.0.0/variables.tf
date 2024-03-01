variable "igw" {
  type = list(object({
    name    = string
    vpc     = string
  }))
}
