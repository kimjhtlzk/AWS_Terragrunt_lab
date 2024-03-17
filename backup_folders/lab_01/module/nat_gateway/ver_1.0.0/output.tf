output "ngw_id" {
  value = { for k, v in aws_nat_gateway.ngw : k => v.id }
}