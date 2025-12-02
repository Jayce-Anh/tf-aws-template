##################### OUTPUTS #####################

output "bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = aws_s3_bucket.backend_state.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.backend_state.arn
}

output "bucket" {
  description = "S3 bucket object"
  value       = aws_s3_bucket.backend_state
}

