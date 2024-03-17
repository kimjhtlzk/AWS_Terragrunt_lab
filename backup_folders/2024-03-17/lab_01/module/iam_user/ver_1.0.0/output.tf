output "policy_arn" {
  value = { for k, v in aws_iam_user.iam_user : k => v.name }
}
