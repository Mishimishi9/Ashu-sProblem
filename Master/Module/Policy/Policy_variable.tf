# variables.tf

variable "policies" {
  description = "List of IAM policy definitions"
  type        = list(object({
    name        = string
    description = string
    policy      = string
  }))
}

variable "role_name" {
  description = "Name for the IAM role"
}

variable "assume_role_policy" {
  description = "IAM role's assume role policy"
}

variable "sourcearn" {
  
}
variable "statementId" {
  
}
variable "function" {
  type = list(string)
}

variable "action" {
  
}
variable "principle" {
  
}