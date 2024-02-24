# locals {
#   ingress_rules = flatten([
#     for sg in var.security_group : [
#       for rule in sg.ingress_rules : merge(rule, { sg_name = sg.name })
#     ]
#   ])
#   egress_rules = flatten([
#     for sg in var.security_group : [
#       for rule in sg.egress_rules : merge(rule, { sg_name = sg.name })
#     ]
#   ])
# }

# resource "aws_security_group" "sg" {
#   for_each = { for security_group in var.security_group : security_group.name => security_group }

#   tags = {
#     Name = each.value.name
#   }
#   name   = each.value.name
#   vpc_id = each.value.vpc
# }

# resource "aws_vpc_security_group_ingress_rule" "example" {
#   description      = 
#   cidr_ipv4        = 
#   ip_protocol      = 
#   from_port        = 
#   to_port          = 
#   security_group_id = aws_security_group.sg.id
# }

# resource "aws_vpc_security_group_egress_rule" "example" {
#   description      = 
#   cidr_ipv4        = 
#   ip_protocol      = 
#   from_port        = 
#   to_port          = 
#   security_group_id = aws_security_group.sg.id
# }







locals {
  ingress_rules = flatten([
    for sg in var.security_group : [
      for rule in sg.ingress_rules : merge(rule, { sg_name = sg.name })
    ]
  ])
  egress_rules = flatten([
    for sg in var.security_group : [
      for rule in sg.egress_rules : merge(rule, { sg_name = sg.name })
    ]
  ])
  
  expanded_ingress_rules = flatten([
    for rule in local.ingress_rules : [
      for port_range in rule.port_range : merge(rule, { from_port = split("-", port_range)[0], to_port = split("-", port_range)[1] })
    ]
  ])
  
  expanded_egress_rules = flatten([
    for rule in local.egress_rules : [
      for port_range in rule.port_range : merge(rule, { from_port = split("-", port_range)[0], to_port = split("-", port_range)[1] })
    ]
  ])
}

resource "aws_security_group" "sg" {
  for_each = { for security_group in var.security_group : security_group.name => security_group }

  tags = {
    Name = each.value.name
  }
  name   = each.value.name
  vpc_id = each.value.vpc
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = { for rule in local.expanded_ingress_rules : "${rule.sg_name}-${rule.rule_name}-${rule.from_port}-${rule.to_port}" => rule }

  description       = each.value.rule_name
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks
  security_group_id = aws_security_group.sg[each.value.sg_name].id
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = { for rule in local.expanded_egress_rules : "${rule.sg_name}-${rule.rule_name}-${rule.from_port}-${rule.to_port}" => rule }

  description       = each.value.rule_name
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks
  security_group_id = aws_security_group.sg[each.value.sg_name].id
}
