output "security_group_ids" {
  value = { for ids in aws_security_group.sg : ids.tags["Name"] => ids.id }
}
