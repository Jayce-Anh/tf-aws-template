############################### OUTPUTS ###############################

#--------- VPC ---------#
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

#------------ACM------------#
output "acm_alb_arn" {
  value = module.acm_alb.cert_arn
}

output "acm_s3cf_arn" {
  value = module.acm_s3cf.cert_arn
}

#------------Secret Manager------------#
output "secret_names" {
  value = module.secret_manager.secret_names
}

output "secret_ids" {
  value     = module.secret_manager.secret_ids
  sensitive = true
}

#------------ECR------------#
output "ecr_url" {
  value = module.ecr.ecr_url
}

output "ecr_name" {
  value = module.ecr.ecr_name
}

#-------------Bastion------------#
output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "bastion_id" {
  value = module.bastion.ec2_id
}

output "bastion_sg_id" {
  value = module.bastion.ec2_sg_id
}

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

#------------FE Pipeline------------#
output "fe_pipeline_name" {
  description = "FE CodePipeline name"
  value       = module.pipeline_fe.codepipeline_name
}

output "fe_pipeline_arn" {
  description = "FE CodePipeline ARN"
  value       = module.pipeline_fe.codepipeline_arn
}

output "fe_build_project_name" {
  description = "FE CodeBuild project name"
  value       = module.build_fe.project_name
}

output "fe_build_project_arn" {
  description = "FE CodeBuild project ARN"
  value       = module.build_fe.project_arn
}

output "fe_artifact_bucket" {
  description = "FE pipeline artifact S3 bucket"
  value       = module.pipeline_fe.bucket_artifact_name
}

#------------BE Pipeline------------#
output "be_pipeline_name" {
  description = "BE CodePipeline name"
  value       = module.pipeline_be.codepipeline_name
}

output "be_pipeline_arn" {
  description = "BE CodePipeline ARN"
  value       = module.pipeline_be.codepipeline_arn
}

output "be_build_project_name" {
  description = "BE CodeBuild project name"
  value       = module.build_be.project_name
}

output "be_build_project_arn" {
  description = "BE CodeBuild project ARN"
  value       = module.build_be.project_arn
}

output "be_artifact_bucket" {
  description = "BE pipeline artifact S3 bucket"
  value       = module.pipeline_be.bucket_artifact_name
}

#------------IAM Roles------------#
output "fe_codebuild_role_arn" {
  description = "FE CodeBuild IAM role ARN"
  value       = module.pipeline_fe.codebuild_role_arn
}

output "be_codebuild_role_arn" {
  description = "BE CodeBuild IAM role ARN"
  value       = module.pipeline_be.codebuild_role_arn
}

output "be_codedeploy_role_arn" {
  description = "BE CodeDeploy IAM role ARN"
  value       = module.pipeline_be.codedeploy_role_arn
}
