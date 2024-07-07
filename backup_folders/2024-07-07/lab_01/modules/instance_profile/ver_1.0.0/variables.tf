variable "instance_profile" {
  type = list(object({
    name    = string
    role    = string
  }))
}