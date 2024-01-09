output "execution_arn" {
  value = aws_api_gateway_rest_api.my_api.execution_arn
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.my_api.id
}

output "resource_id" {
  value = aws_api_gateway_resource.root.id
}