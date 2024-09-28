output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = module.api_gateway.api_gateway_url
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "cloudfront_url" {
  description = "CloudFront URL"
  value       = module.cloudfront.cloudfront_url
}
