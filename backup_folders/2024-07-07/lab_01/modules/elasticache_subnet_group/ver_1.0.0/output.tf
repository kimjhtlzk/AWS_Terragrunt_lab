output "subnet_group_name" {
  value = { for sg in aws_elasticache_subnet_group.subnet_group : sg.name => sg.name }
}