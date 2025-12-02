######################## VARIABLES ##########################

#---------S3-Bucket-Pipeline---------#
variable "s3_force_del" {
  type = bool
  default = true
  description = "Force destroy the S3 bucket"
}

#---------FE-Pipeline---------#
variable "fe_enable_ecs_deploy" {
  type = bool
  default = false
  description = "Enable ECS deployment for FE"
}

variable "fe_pipeline_name" {
  type = string
  description = "Pipeline name"
}

variable "fe_build_name" {
  type = string
  description = "Build name"
}

variable "fe_buildspec_file" {
  type = string
  description = "Path to the FE buildspec file"
}

variable "fe_ecr_image_tag" {
  type = string
  description = "FE ECR image tag"
  default = "latest"
}

variable "fe_env_vars_codebuild" {
  type = map(any)
  description = "Environment variables for the codebuild project"
}

#---------BE-Pipeline---------#
variable "be_enable_ecs_deploy" {
  type = bool
  default = true
  description = "Enable ECS deployment for BE"
}

variable "be_pipeline_name" {
  type = string
  description = "BE pipeline name"
}

variable "be_build_name" {
  type = string
  description = "BE build name"
}

variable "be_buildspec_file" {
  type = string
  description = "Path to the BE buildspec file"
}

variable "be_ecr_image_tag" {
  type = string
  description = "BE ECR image tag"
  default = "latest"
}

variable "be_env_vars_codebuild" {
  type = map(any)
  description = "Environment variables for the BE codebuild project"
}
