output "instance_profile_arn" {
  value = { for k, v in aws_iam_instance_profile.instance_profile : k => v.arn }
}
