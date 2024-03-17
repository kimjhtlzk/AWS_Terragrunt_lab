resource "aws_eip" "eip" {
    for_each = { for eip in var.eip : eip.name => eip }

    tags = {
        Name = each.value.name
    }
    domain    = "vpc"
}