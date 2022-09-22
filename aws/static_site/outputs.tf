output "bucket_id" {
  value = aws_s3_bucket.mod.id
}

output "website_domain" {
  value = aws_s3_bucket.mod.website_domain
}

output "website_endpoint" {
  value = aws_s3_bucket.mod.website_endpoint
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.mod.domain_name
}

