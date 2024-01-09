
resource "aws_api_gateway_rest_api" "my_api" {
  name = var.api_name
  description = var.description

  endpoint_configuration {
    types = var.types1
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = var.path_part
}

resource "aws_api_gateway_method" "proxy" {
  for_each = {
    for method in var.methods : method => method
  }
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = each.key
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each = {
    for idx, method in var.methods : idx => method
  }
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = each.value
  integration_http_method = each.value
  type = var.type
  uri = var.Lambda_uri[each.key]
}

resource "aws_api_gateway_method_response" "proxy" {
  for_each = {
    for idx, method in var.methods : idx => method
  }
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = each.value
  status_code = var.status_code[each.key]
  # response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers" = true,
  #   "method.response.header.Access-Control-Allow-Methods" = true,
  #   "method.response.header.Access-Control-Allow-Origin" = true
  # }
  depends_on = [ aws_api_gateway_integration.lambda_integration ]
}

resource "aws_api_gateway_integration_response" "proxy" {
     for_each = {
    for idx, method in var.methods : idx => method
  }
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = each.value
  status_code = aws_api_gateway_method_response.proxy[each.key].status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
# }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
   // aws_api_gateway_integration.options_integration, # Add this line
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = var.stage_name
}