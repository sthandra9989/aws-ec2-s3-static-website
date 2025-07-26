provider "aws" {
  region = var.aws_region
}

# S3 bucket for website hosting
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name        = "Static Website"
    Environment = var.environment
  }
}

# Enable website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Enable public access
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Bucket ACL
resource "aws_s3_bucket_acl" "website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

# Bucket policy
resource "aws_s3_bucket_policy" "website" {
  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]

  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      },
    ]
  })
}

# Upload website files
resource "aws_s3_object" "html" {
  for_each = fileset("${path.module}/../website/", "**/*.{html,css,js,jpg,jpeg,png,gif}")

  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = "${path.module}/../website/${each.value}"
  etag         = filemd5("${path.module}/../website/${each.value}")
  content_type = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
} 