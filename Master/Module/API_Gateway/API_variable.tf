variable "api_name" {
}
variable "description" {
  
}

variable "types1" {
    type = list(string)
    default = ["REGIONAL"]
}

variable "path_part" {
  
}

variable "methods" {
  type = list(string)
}

variable "authorization" {
  default = "NONE"
}

variable "stage_name" {
  default = "dev"
}

# variable "integration_http_method" {
#   default = "POST"
# }

variable "Lambda_uri" {
}

variable "type" {
  default = "AWS_PROXY"
}

variable "status_code" {
}

variable "authorizer_id" {
  
}