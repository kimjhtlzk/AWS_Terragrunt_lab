variable "iam_policy" {
  type = list(object({
    name    = string
    policy  = string
  })) 
}

