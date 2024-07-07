output "ebs_id" {
  value = { for k, v in aws_ebs_volume.ebs_volume : k => v.id }
}
output "ebs_arn" {
  value = { for k, v in aws_ebs_volume.ebs_volume : k => v.arn }
}
