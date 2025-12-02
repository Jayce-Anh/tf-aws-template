##################### OUTPUTS #####################

output "prod_bucket_name" {
  description = "Prod S3 bucket name"
  value       = module.backend_prod.bucket_name
}

output "dev_bucket_name" {
  description = "Dev S3 bucket name"
  value       = module.backend_dev.bucket_name
} 

output "prod_bucket_arn" {
  description = "Prod S3 bucket ARN"
  value       = module.backend_prod.bucket_arn
}

output "dev_bucket_arn" {
  description = "Dev S3 bucket ARN"
  value       = module.backend_dev.bucket_arn
}