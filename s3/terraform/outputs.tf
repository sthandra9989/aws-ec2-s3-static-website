output "website_endpoint" {
  description = "S3 static website hosting endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_domain" {
  description = "S3 static website hosting domain"
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "website_url" {
  description = "S3 static website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
} 