resource "aws_internet_gateway" "igw" {
  for_each = { for igw in var.igw : igw.name => igw }

  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway_attachment" "igw_att" {
  for_each = {
    for igw in var.igw : igw.name => igw if igw.vpc != null
  }

  internet_gateway_id = aws_internet_gateway.igw[each.key].id
  vpc_id              = each.value.vpc
}
