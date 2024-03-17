resource "aws_elasticache_subnet_group" "subnet_group" {
  for_each = { for elasticache_subnet_group in var.elasticache_subnet_group : elasticache_subnet_group.name => elasticache_subnet_group }

  name        = each.value.name
  subnet_ids  = each.value.subnets
}
