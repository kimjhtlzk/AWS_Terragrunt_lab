variable "iam_group" {
  type = list(object({
    name    = string
    policy  = list(string)
    users   = list(string)
  }))
}

