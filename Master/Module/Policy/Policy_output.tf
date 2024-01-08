# outputs.tf

output "policy_arns" {
  value = [for policy in aws_iam_policy.policies : policy.arn]
}

output "role_name" {
  value = aws_iam_role.iam_role.name
}

output "role_arn" {
  value = aws_iam_role.iam_role.arn
}