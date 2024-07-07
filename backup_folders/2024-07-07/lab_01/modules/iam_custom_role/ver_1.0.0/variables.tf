variable "iam_role" {
  type = list(object({
    name                = string
    attach_policy       = list(string)
    assume_role_policy  = string
  })) 
}