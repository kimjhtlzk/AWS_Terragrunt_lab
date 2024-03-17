output "vpc_id" {
  value = {
    for k, vpc in aws_vpc.vpc : 
    vpc.tags["Name"] => {
      vpc_cidr = k
      vpc_id = vpc.id
    }
  }
}

output "subnets" {
  value = aws_subnet.subnet
}

output "subnets_ids" {
  value = { for ids in aws_subnet.subnet : ids.tags["Name"] => ids.id }
}

output "vpc_ipv6_cidr_block" {
  value = {
    for k, vpc in aws_vpc.vpc : 
    vpc.tags["Name"] => {
      vpc_cidr = k
      ipv6_cidr = vpc.ipv6_cidr_block
    }
  }
}

