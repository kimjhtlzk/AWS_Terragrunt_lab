output "eip_id" {
  value = { for k, v in aws_eip.eip : k => v.id }
}
