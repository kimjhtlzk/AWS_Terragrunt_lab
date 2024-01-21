output "vpc_id" {
  value = { for k, vpc in aws_vpc.vpc : k => vpc.id }
}
output "subnets" {
  value = aws_subnet.subnet
}
output "vpc_ipv6_cidr_block" {
  value = { for v in aws_vpc.vpc : v.tags["Name"] => v.ipv6_cidr_block }
}