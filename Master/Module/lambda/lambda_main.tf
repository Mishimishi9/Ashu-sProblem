resource "aws_lambda_function" "my_lambda" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.source_code_path
  role          = var.role_arn
}
