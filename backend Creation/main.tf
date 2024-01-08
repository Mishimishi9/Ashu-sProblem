resource "aws_s3_bucket" "backend_s3" {
  bucket = "mys3-bucket-for-statefile-1234"
}

# resource "aws_s3_bucket_acl" "backend_s3" {
#   bucket = aws_s3_bucket.backend_s3.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform_state_1"
    read_capacity  = 1
    write_capacity = 1
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}