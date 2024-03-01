output "igw_id" {
  value = { for k, v in aws_internet_gateway.igw : k => v.id }
}
