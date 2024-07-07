locals {
  subnets = flatten([
    for idx, vpc in var.vpcs : [
      for subnet in vpc.subnets : {
        vpc_cidr = vpc.cidr_block
        subnet = subnet
      }
    ]
  ])
}

resource "aws_vpc" "vpc" {
  for_each = { for vpc in var.vpcs : vpc.cidr_block => vpc }

  tags = {
    Name = each.value.name
  }

  cidr_block                       = each.key
  assign_generated_ipv6_cidr_block = each.value.use_ipv6_cidr_block
  enable_dns_hostnames             = true
}

resource "aws_subnet" "subnet" {
  for_each = { for subnet in local.subnets : "${subnet.subnet.availability_zone}-${subnet.subnet.subnet_cidr}" => subnet }

  vpc_id    = aws_vpc.vpc[each.value.vpc_cidr].id

  tags = merge(
    {
      Name = each.value.subnet.subnet_name
    },
    {
      for key, value in each.value.subnet.tags : key => value
    }
  )

  cidr_block              = each.value.subnet.subnet_cidr
  ipv6_cidr_block         = each.value.subnet.ipv6_cidr_block == null ? null : each.value.subnet.ipv6_cidr_block
  availability_zone       = each.value.subnet.availability_zone
  map_public_ip_on_launch = each.value.subnet.autoassign_public == true ? true : false
}

resource "aws_default_security_group" "default" {
  for_each = { for vpc in var.vpcs : vpc.cidr_block => vpc }

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name = "${each.value.name}-default-sg"
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
