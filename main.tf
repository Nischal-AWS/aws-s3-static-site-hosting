# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "nischal-s3-bucket-2025"  # Replace with a valid bucket name
}

# Set Ownership Controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my_bucket.bucket  # Reference the bucket name dynamically

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  # Ensure this runs after bucket creation
}

# Set Public Access Block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_bucket.bucket  # Reference the bucket name dynamically

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  # Ensure this runs after bucket creation
}

# Set ACL (Access Control List) to Public Read
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]
  bucket = aws_s3_bucket.my_bucket.bucket  # Reference the bucket name dynamically
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.bucket  # Remove quotes to correctly reference the bucket
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
  acl    = "public-read"
}


 resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.bucket

  index_document {
    suffix = "index.html"
  }
depends_on = [aws_s3_bucket_acl.example]
}



