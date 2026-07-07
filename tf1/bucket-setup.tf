

# 1. Generate a random suffix to guarantee a unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 2. Create the S3 Bucket for State Storage
resource "aws_s3_bucket" "terraform_state" {
  # S3 bucket names must be globally unique across all AWS accounts
  bucket        = "zuriapp-terraform-state-${random_id.bucket_suffix.hex}"
  force_destroy = false # Protects the state from accidental deletion

  tags = {
    Name        = "Terraform State Backend"
    Environment = "Production"
  }
}

# 3. Enable Versioning (Crucial for state file recovery)
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Enable Server-Side Encryption (Encrypts the infrastructure secrets)
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 5. Block all public access to the bucket for safety
resource "aws_s3_bucket_public_access_block" "state_public_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 6. Create the DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "zuriapp-terraform-state-831e2265"
  billing_mode = "PAY_PER_REQUEST" # Cost-efficient billing configuration
  hash_key     = "LockID"         # This exact attribute string is required by Terraform

  attribute {
    name = "LockID"
    type = "S" # String type
  }

  tags = {
    Name = "Terraform State Lock Table"
  }
}

# 7. Print the created bucket name to the terminal window
output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "Copy this value into the backend configurations block"
}
