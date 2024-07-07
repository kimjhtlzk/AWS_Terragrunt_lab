resource "aws_vpc_endpoint" "ep" {
  for_each = { for eps in var.eps : eps.vpc => eps }

  vpc_id            = each.value.vpc
  service_name      = "com.amazonaws.${each.value.region}.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = each.value.name
  }
}
