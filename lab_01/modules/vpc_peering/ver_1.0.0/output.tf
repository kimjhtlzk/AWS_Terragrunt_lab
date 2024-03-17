output "vpc_peering_id" {
  value = { for k, v in aws_vpc_peering_connection.vpc_peer : k => v.id }
}
