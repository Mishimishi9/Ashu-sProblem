module "my_lambda_function" {
  source = "./Module/lambda"  # Update with the correct path
  
  function_name   = var.function_name
  handler         = var.lambda_handler
  runtime         = var.runtime
  source_code_path = "HelloWorld.zip"
  role_arn        = module.my_iam_policies.role_arn
  # Other input variables specific to your module...
}

module "my_deletelambda_function" {
  source = "./Module/lambda"  # Update with the correct path
  
  function_name   = "newDeleteFunction"
  handler         = var.lambda_handler
  runtime         = var.runtime
  source_code_path = "HelloWorld.zip"
  role_arn        = module.my_iam_policies.role_arn
  # Other input variables specific to your module...
}

module "my_iam_policies" {
  source = "./Module/Policy"  # Update with the correct path
  statementId = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function = [module.my_lambda_function.function_name, module.my_deletelambda_function.function_name]
  principle = "apigateway.amazonaws.com"

  sourcearn = ["${module.my_api_gateway.execution_arn}/*/POST/mypath", "${module.my_api_gateway.execution_arn}/*/DELETE/mypath"]
  policies = [
    {
      name        = "Policy1"
      description = "Description of Policy1"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect    = "Allow",
            Action    = "dynamodb:*",
            # Resource  = "*"
            Resource  = "${aws_dynamodb_table.basic-dynamodb-table.arn}"
          },
          {
            Effect    = "Allow",
            Action    = "logs:*",
            Resource  = "*"
          },
          # Add more statements as needed
        ]
      })
    },
    {
      name        = "Policy2"
      description = "Description of Policy2"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect    = "Allow",
            Action    = "ec2:Describe*",
            Resource  = "*"
          },
          # Add more statements as needed
        ]
      })
    },
    # Add more policies as needed
  ]
  role_name = "MyCustomRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

output "policy_arns" {
  value = module.my_iam_policies.policy_arns
  # Output other values from the module as needed...
}

module "my_api_gateway" {
  source = "./Module/API_Gateway"  # Update with correct path to your module
  description = "My API Gateway"
  types1 = ["REGIONAL"]
  authorizer_id = aws_api_gateway_authorizer.demo.id
  api_name          = "my-api"
  path_part         = "mypath"
  authorization = "NONE"
  Lambda_uri = [module.my_lambda_function.lambda_invokearn, module.my_deletelambda_function.lambda_invokearn]
  status_code = ["200","200"]
  methods     = ["POST", "DELETE"]  # Specify the methods here

 // depends_on = [ module.my_deletelambda_function, module.my_lambda_function ]
}

output "api_arn" {
  value = module.my_api_gateway.execution_arn
}

resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
}
resource "aws_cognito_user_pool_client" "client" {
  name = "client_pool_by_rahul"
  allowed_oauth_flows_user_pool_client = true
  generate_secret = false
  allowed_oauth_scopes = ["aws.cognito.signin.user.admin","email", "openid", "profile"]
  allowed_oauth_flows = ["implicit", "code"]
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers = ["COGNITO"]

  user_pool_id = aws_cognito_user_pool.pool.id
  callback_urls = ["https://example.com"]
  logout_urls = ["https://sumeet.life"]
}

resource "aws_cognito_user" "example" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username = "rahul.bishnoi" #aws cognito-idp admin-initiate-auth --user-pool-id ap-south-1_WEJLSXjdg --client-id 6kujqfqqvet4dt5q076g3vl4ml --auth-flow ADMIN_NO_SRP_AUTH --auth-parameters USERNAME=rahul.bishnoi,PASSWORD=Test@123
  password = "Test@123"
}

resource "aws_api_gateway_authorizer" "demo" {
  name = "my_apig_authorizer2"
  rest_api_id = module.my_api_gateway.rest_api_id
  type = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.pool.arn]
}

output "user_pool_clientid" {
  value = aws_cognito_user_pool_client.client.id
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "accountId"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "accountId_name"

  attribute {
    name = "accountId_name"
    type = "S"
  }

  # attribute {
  #   name = "status"
  #   type = "S"
  # }

  tags = {
    Name        = "dynamodb-table"
    Environment = "Dev"
  }
}