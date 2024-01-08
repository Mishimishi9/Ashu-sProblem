resource "aws_iam_policy" "policies" {
  count = length(var.policies)

  name        = var.policies[count.index].name
  description = var.policies[count.index].description
  policy      = var.policies[count.index].policy
}

resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  for_each = {
    for idx, policy in aws_iam_policy.policies : idx => policy.arn
  }

  name       = "policy-attachment-${each.key}"
  policy_arn = each.value
  roles      = [aws_iam_role.iam_role.name]
}

resource "aws_lambda_permission" "here" {
  statement_id = var.statementId
  action = var.action
  function_name = var.function
  principal = var.principle

  source_arn = var.sourcearn 
}