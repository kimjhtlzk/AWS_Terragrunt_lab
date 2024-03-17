output "policy_arn" {
  value = { for k, v in aws_iam_policy.policy : k => v.arn }
}
