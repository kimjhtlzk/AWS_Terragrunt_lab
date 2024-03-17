resource "aws_route_table" "route_table" {
    for_each = { for route_table in var.route_table : route_table.name => route_table }

    tags = {
        Name = each.value.name
    }

    vpc_id = each.value.vpc

    dynamic "route" {
        for_each = each.value.rule
        content {
            cidr_block                = route.value.cidr_block
            nat_gateway_id            = route.value.resource_type == "ngw" ? route.value.resource_name : null
            gateway_id                = route.value.resource_type == "igw" ? route.value.resource_name : null
            vpc_peering_connection_id = route.value.resource_type == "peering" ? route.value.resource_name : null
        }
    }

}

# resource "aws_route_table_association" "route_table_att" {
#   count           = length(each.value.asso_subnets)
  
#   subnet_id       = each.value.asso_subnets[count.index]
#   route_table_id  = aws_route_table.route_table.id
# }