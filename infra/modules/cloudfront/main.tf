resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "Frontend S3 bucket OAI"
}

resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for Frontend S3 bucket"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GB"]
    }
  }

  tags = {
    Name        = "Frontend CloudFront Distribution"
    Environment = "Production"
  }
}

output "cloudfront_url" {
  description = "CloudFront URL"
  value       = aws_cloudfront_distribution.frontend_distribution.domain_name
}

output "origin_access_identity_arn" {
  value = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
}
