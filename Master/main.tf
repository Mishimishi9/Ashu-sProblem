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

  sourcearn = "${module.my_api_gateway.execution_arn}/*/*/*"
  policies = [
    {
      name        = "Policy1"
      description = "Description of Policy1"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect    = "Allow",
            Action    = "s3:GetObject",
            Resource  = "arn:aws:s3:::example-bucket/*"
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