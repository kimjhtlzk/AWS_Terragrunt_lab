resource "aws_iam_policy" "policy" {
  for_each = { for policy in var.iam_policy : policy.name => policy }

  name      = each.value.name
  path      = "/"
  policy    = each.value.policy
}


