resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = "cicd-pipeline-frontend-${random_uuid.uuid.result}"
  force_destroy = true
  tags = {
    Name        = "Frontend S3 bucket"
    Environment = "Production"
  }
}

resource "random_uuid" "uuid" {}

resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.cloudfront_origin_access_identity_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.frontend_bucket.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
}
