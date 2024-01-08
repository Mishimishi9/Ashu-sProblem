# outputs.tf

output "lambda_arn" {
  value = aws_lambda_function.my_lambda.arn
}

output "lambda_invokearn" {
  value = aws_lambda_function.my_lambda.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.my_lambda.function_name
}
# Define other outputs as needed...
