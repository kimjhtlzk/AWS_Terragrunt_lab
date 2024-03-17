locals {
  ingress_rules_flat = flatten([for sg in var.security_group : [for rule in sg.ingress_rules : merge(rule, { sg_name : sg.name })]])
  egress_rules_flat = flatten([for sg in var.security_group : [for rule in sg.egress_rules : merge(rule, { sg_name : sg.name })]])
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
  for_each = { for rule in local.ingress_rules_flat : rule.rule_name => rule }

  description       = each.value.rule_name
  from_port         = split("-", each.value.port_range[0])[0]
  to_port           = split("-", each.value.port_range[0])[1]
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks
  security_group_id = aws_security_group.sg[each.value.sg_name].id
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = { for rule in local.egress_rules_flat : rule.rule_name => rule }

  description       = each.value.rule_name
  from_port         = split("-", each.value.port_range[0])[0]
  to_port           = split("-", each.value.port_range[0])[1]
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks
  security_group_id = aws_security_group.sg[each.value.sg_name].id
}
