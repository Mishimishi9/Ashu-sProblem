provider "aws" {
    region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "mys3-bucket-for-statefile-1234"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform_state_1"
  }
}