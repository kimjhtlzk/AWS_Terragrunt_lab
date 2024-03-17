resource "aws_iam_instance_profile" "instance_profile" {
  for_each = { for instance_profile in var.instance_profile : instance_profile.name => instance_profile }

  name = each.value.name
  role = each.value.role
}