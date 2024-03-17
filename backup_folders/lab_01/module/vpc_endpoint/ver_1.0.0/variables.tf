variable "eps" {
  type = list(object({
    name    = string
    vpc     = string
    region  = string
  }))
}
