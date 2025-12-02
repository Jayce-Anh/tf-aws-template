############################### OUTPUTS ###############################

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


