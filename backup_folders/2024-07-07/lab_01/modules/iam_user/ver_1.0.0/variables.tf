variable "iam_user" {
  type = list(object({
    name    = string
    policy  = list(string)
  }))
}

