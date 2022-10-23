provider "aws" {
    region = var.aws_region
}

# Create the tfstate bucket
resource "aws_s3_bucket" "terraform_state" {
    bucket = "${var.id}-tfstate"
}

# Enable versioning so we can rollback to previous versions just in case
resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

# Enable server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
        apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
        }
    }
}

# Disable public access
resource "aws_s3_bucket_acl" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id
    acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure a dynamodb table for terraform locks
resource "aws_dynamodb_table" "terraform_locks" {
    name         = "${var.id}-tflocks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}

# Output variables for convenience
output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "S3 bucket name"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "DynamoDB table name"
}