############################# CICD ###############################
#-------------------FE pipeline----------------
module "pipeline_fe" {
  source            = "../../../modules/cicd/code_pipeline"
  project           = local.project
  tags              = local.tags
  project_name      = module.build_fe.project_name
  git_org           = local.github.fe.organization
  git_repo          = local.github.fe.name
  git_branch        = local.github.fe.branch
  pipeline_name     = var.fe_pipeline_name
  git_token         = local.github.fe.token
  enable_ecs_deploy = var.fe_enable_ecs_deploy
  s3_force_del      = var.s3_force_del
}

module "build_fe" {
  source             = "../../../modules/cicd/code_build"
  project            = local.project
  tags               = local.tags
  build_name         = var.fe_build_name
  buildspec_file     = var.fe_buildspec_file
  env_vars_codebuild = merge(
    var.fe_env_vars_codebuild,
    {
      S3_BUCKET_NAME  = data.terraform_remote_state.application.outputs.cloudfront_s3_bucket
      DISTRIBUTION_ID = data.terraform_remote_state.application.outputs.cloudfront_distribution_id
      SECRET_MANAGER  = data.terraform_remote_state.dependence.outputs.secret_ids["fe"]
      REGION          = local.project.region
    }
  )
  codebuild_role_arn = module.pipeline_fe.codebuild_role_arn
}

# -------------------BE pipeline----------------
module "pipeline_be" {
  source            = "../../../modules/cicd/code_pipeline"
  project           = local.project
  tags              = local.tags
  project_name      = module.build_be.project_name
  git_org           = local.github.be.organization
  git_repo          = local.github.be.name
  git_branch        = local.github.be.branch
  pipeline_name     = var.be_pipeline_name
  git_token         = local.github.be.token
  enable_ecs_deploy = var.be_enable_ecs_deploy
  ecs_cluster_name  = data.terraform_remote_state.application.outputs.ecs_cluster_name
  ecs_service_name  = data.terraform_remote_state.application.outputs.ecs_service_names["be"]
  s3_force_del      = var.s3_force_del
}

module "build_be" {
  source             = "../../../modules/cicd/code_build"
  project            = local.project
  tags               = local.tags
  build_name         = var.be_build_name
  buildspec_file     = var.be_buildspec_file
  env_vars_codebuild = merge(
    var.be_env_vars_codebuild,
    {
      REGISTRY_URL     = data.terraform_remote_state.dependence.outputs.ecr_url
      SERVICE          = data.terraform_remote_state.application.outputs.ecs_service_names["be"]
      SECRET_MANAGER   = data.terraform_remote_state.dependence.outputs.secret_ids["be"]
      ECS_CLUSTER_NAME = data.terraform_remote_state.application.outputs.ecs_cluster_name
      ECR_URL          = data.terraform_remote_state.dependence.outputs.ecr_url
      REGION           = local.project.region
      CONTAINER_NAME   = "${local.project.env}-${local.project.name}-${var.be_build_name}"
      ECR_IMAGE_TAG    = var.be_ecr_image_tag
    }
  )
  codebuild_role_arn = module.pipeline_be.codebuild_role_arn
}