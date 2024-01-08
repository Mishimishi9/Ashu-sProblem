# variables.tf

variable "function_name" {
  description = "Name for the Lambda function"
  default = ""
}

variable "handler" {
  description = "Lambda function handler"
  default = ""
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  default = ""
}

variable "source_code_path" {
  description = "Path to the Lambda function source code ZIP file"
  default = ""
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
  default = ""
}

# Define other variables as needed...
