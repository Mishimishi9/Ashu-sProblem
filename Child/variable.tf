variable "AZsps" {
    type = list
    default = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}

variable "public_subnet" {
  type = list
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "private_subnet" {
  type = list
  default = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]
}