resource "aws_iam_role" "role" {
  for_each = { for iam_role in var.iam_role : iam_role.name => iam_role }

  name                = each.value.name
  assume_role_policy  = each.value.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each = {
    for role_policy in flatten([
      for role in var.iam_role : [
        for policy in role.attach_policy : {
          role_name = role.name
          policy_arn = policy
        }
      ]
    ]) : "${role_policy.role_name}-${role_policy.policy_arn}" => role_policy
  }

  role       = aws_iam_role.role[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

