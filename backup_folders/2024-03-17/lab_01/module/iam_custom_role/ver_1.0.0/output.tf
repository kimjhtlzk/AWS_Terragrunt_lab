output "role_arn" {
  value = { for k, v in aws_iam_role.role : k => v.arn }
}
