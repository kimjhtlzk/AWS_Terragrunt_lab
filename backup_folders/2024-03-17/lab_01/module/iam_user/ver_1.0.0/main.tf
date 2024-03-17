resource "aws_iam_user" "iam_user" {
  for_each = { for iam_user in var.iam_user : iam_user.name => iam_user }

  force_destroy = "false"
  name          = each.value.name
  path          = "/"
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attach" {
  for_each = {
    for user_policy in flatten([
      for user in var.iam_user : [
        for policy in user.policy : {
          user_name = user.name
          policy_arn = policy
        }
      ]
    ]) : "${user_policy.user_name}-${user_policy.policy_arn}" => user_policy
  }

  user       = aws_iam_user.iam_user[each.value.user_name].name
  policy_arn = each.value.policy_arn
}



