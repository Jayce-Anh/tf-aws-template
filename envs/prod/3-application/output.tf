############################### OUTPUTS ###############################

#------------ALB------------#
output "alb_arn" {
  description = "ARN of the load balancer"
  value       = module.alb.lb_arn
}

output "alb_target_group_arns" {
  description = "ARNs of all target groups"
  value       = module.alb.tg_arns
}

#------------CloudFront------------#
output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.cf_distribution_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (for cache invalidation)"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_s3_bucket" {
  description = "S3 bucket name for CloudFront static hosting"
  value       = module.cloudfront.cfs3_bucket
}

#------------RDS------------#
output "rds_endpoint" {
  description = "RDS instance endpoint (host:port)"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

#------------Redis------------#
output "redis_endpoint" {
  description = "Redis cluster endpoint"
  value       = module.redis.redis_cluster_endpoint
  sensitive   = true
}

output "redis_cluster_id" {
  description = "Redis cluster ID"
  value       = module.redis.redis_cluster_id
}

#------------ECS------------#
output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.ecs.cluster_arn
}

output "ecs_service_names" {
  description = "ECS service names"
  value       = module.ecs.service_name
}

output "ecs_log_group_names" {
  description = "CloudWatch log group names for ECS tasks"
  value       = module.ecs.cloudwatch_log_group_name
}
