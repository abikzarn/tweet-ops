
# Create S3 bucket
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-tfstate-devops-abdessalam-2024"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_state_bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Create DynamoDB table
resource "aws_dynamodb_table" "state_lock" {
  name         = "state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Configure Terraform backend
terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-devops-abdessalam-2024"
    key            = "Global/mystatefile/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state_lock"
    encrypt        = true
  }
}