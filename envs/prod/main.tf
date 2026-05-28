################################ MAIN #################################

#---------VPC---------#
module "vpc" {
  source     = "../../modules/vpc"
  project    = local.project
  tags       = local.tags
  cidr_block = var.cidr_block
  subnet_az  = var.subnet_az
}

#---------ACM---------#
# Certificate for ALB
module "acm_alb" {
  source  = "../../modules/acm"
  project = local.project
  tags    = local.tags
  domain  = var.domain_alb
  region  = local.project.region
}

# Certificate for CloudFront
module "acm_s3cf" {
  source  = "../../modules/acm"
  project = local.project
  tags    = local.tags
  domain  = var.domain_s3cf
  region  = local.project.region
}

#---------Secret Manager---------#
module "secret_manager" {
  source  = "../../modules/secret_manager"
  project = local.project
  tags    = local.tags
  secrets = var.secrets
}

#---------ECR---------#
module "ecr" {
  source          = "../../modules/ecr"
  project         = local.project
  tags            = local.tags
  s3_force_del    = var.ecr_force_destroy
  source_services = var.source_services
}

#---------Bastion---------#
module "bastion" {
  source         = "../../modules/ec2"
  project        = local.project
  tags           = local.tags
  enabled_eip    = var.enabled_eip
  instance_type  = var.instance_type
  instance_name  = var.instance_name
  iops           = var.iops
  volume_size    = var.volume_size
  vpc_id         = module.vpc.vpc_id
  path_user_data = var.path_user_data
  key_name       = var.key_name
  subnet_id      = module.vpc.public_subnet_ids[0]

  sg_ingress = var.sg_ingress
  sg_egress  = var.sg_egress
}

#-----------External LB------------#
module "alb" {
  source                 = "../../modules/alb/external"
  project                = local.project
  tags                   = local.tags
  lb_name                = var.lb_name
  vpc_id                 = module.vpc.vpc_id
  dns_cert_arn           = module.acm_alb.cert_arn
  enable_https_listener  = var.enable_https_listener
  subnet_ids             = module.vpc.public_subnet_ids
  source_ingress_sg_cidr = var.source_ingress_sg_cidr

  target_groups = {
    be = {
      name              = var.target_groups.be.name
      service_port      = var.target_groups.be.service_port
      health_check_path = var.target_groups.be.health_check_path
      priority          = var.target_groups.be.priority
      host_header       = var.target_groups.be.host_header
      target_type       = var.target_groups.be.target_type
      ec2_id            = var.target_groups.be.ec2_id
    }
  }
}

#------------CloudFront------------#
module "cloudfront" {
  source                = "../../modules/cloudfront"
  project               = local.project
  tags                  = local.tags
  service_name          = var.service_name
  cf_cert_arn           = module.acm_s3cf.cert_arn
  s3_force_del          = var.cloudfront_force_destroy
  cloudfront_domain     = var.cloudfront_domain
  custom_error_response = var.custom_error_response
}

#-----------RDS------------#
module "rds" {
  source     = "../../modules/database/rds"
  project    = local.project
  tags       = local.tags
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  rds_name   = var.rds_name
  db_name    = local.project.name
  multi_az   = var.rds_multi_az
  allowed_sg_ids_access_rds = [
    module.bastion.ec2_sg_id,
    module.ecs.ecs_tasks_sg_id,
  ]
  rds_storage_type = var.rds_storage_type
  rds_iops         = var.rds_iops
  rds_throughput   = var.rds_throughput

  rds_storage     = var.rds_storage
  rds_max_storage = var.rds_max_storage

  rds_password = var.rds_password
  rds_username = var.rds_username

  rds_class                             = var.rds_class
  rds_engine                            = var.rds_engine
  rds_engine_version                    = var.rds_engine_version
  rds_port                              = var.rds_port
  rds_backup_retention_period           = var.rds_backup_retention_period
  performance_insights_retention_period = var.performance_insights_retention_period

  rds_family        = var.rds_family
  aws_db_parameters = var.aws_db_parameters
}

#------------Redis------------#
module "redis" {
  source                           = "../../modules/database/redis"
  project                          = local.project
  tags                             = local.tags
  vpc_id                           = module.vpc.vpc_id
  subnet_ids                       = module.vpc.private_subnet_ids
  redis_name                       = var.redis_name
  redis_engine                     = var.redis_engine
  redis_engine_version             = var.redis_engine_version
  redis_port                       = var.redis_port
  redis_num_cache_nodes            = var.redis_num_cache_nodes
  redis_node_type                  = var.redis_node_type
  redis_snapshot_retention_limit   = var.redis_snapshot_retention_limit
  redis_family                     = var.redis_family
  allowed_cidr_blocks_access_redis = var.allowed_cidr_blocks_access_redis
  allowed_sg_ids_access_redis = [
    module.ecs.ecs_tasks_sg_id
  ]
  redis_parameters = var.redis_parameters
}

#-----------ECS------------#
module "ecs" {
  source           = "../../modules/ecs"
  project          = local.project
  tags             = local.tags
  vpc_id           = module.vpc.vpc_id
  lb_sg_id         = module.alb.lb_sg_id
  target_group_arn = module.alb.tg_arns["be"]
  subnets          = module.vpc.private_subnet_ids
  task_definitions = {
    "be" = {
      container_name       = var.ecs_task_definitions.be.container_name
      container_image      = "${local.project.account_ids[0]}.dkr.ecr.${local.project.region}.amazonaws.com/${module.ecr.ecr_name}:latest"
      desired_count        = var.ecs_task_definitions.be.desired_count
      cpu                  = var.ecs_task_definitions.be.cpu
      memory               = var.ecs_task_definitions.be.memory
      container_port       = var.ecs_task_definitions.be.container_port
      host_port            = var.ecs_task_definitions.be.host_port
      health_check_path    = var.ecs_task_definitions.be.health_check_path
      enable_load_balancer = var.ecs_task_definitions.be.enable_load_balancer
      load_balancer = {
        target_group_port = var.ecs_task_definitions.be.load_balancer.target_group_port
        container_port    = var.ecs_task_definitions.be.load_balancer.container_port
      }
    }
  }
}

#-------------------FE pipeline----------------#
module "pipeline_fe" {
  source            = "../../modules/cicd/code_pipeline"
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
  source         = "../../modules/cicd/code_build"
  project        = local.project
  tags           = local.tags
  build_name     = var.fe_build_name
  buildspec_file = var.fe_buildspec_file
  env_vars_codebuild = merge(
    var.fe_env_vars_codebuild,
    {
      S3_BUCKET_NAME  = module.cloudfront.cfs3_bucket
      DISTRIBUTION_ID = module.cloudfront.distribution_id
      SECRET_MANAGER  = module.secret_manager.secret_ids["fe"]
      REGION          = local.project.region
    }
  )
  codebuild_role_arn = module.pipeline_fe.codebuild_role_arn
}

#-------------------BE pipeline----------------#
module "pipeline_be" {
  source            = "../../modules/cicd/code_pipeline"
  project           = local.project
  tags              = local.tags
  project_name      = module.build_be.project_name
  git_org           = local.github.be.organization
  git_repo          = local.github.be.name
  git_branch        = local.github.be.branch
  pipeline_name     = var.be_pipeline_name
  git_token         = local.github.be.token
  enable_ecs_deploy = var.be_enable_ecs_deploy
  ecs_cluster_name  = module.ecs.cluster_name
  ecs_service_name  = module.ecs.service_name["be"]
  s3_force_del      = var.s3_force_del
}

module "build_be" {
  source         = "../../modules/cicd/code_build"
  project        = local.project
  tags           = local.tags
  build_name     = var.be_build_name
  buildspec_file = var.be_buildspec_file
  env_vars_codebuild = merge(
    var.be_env_vars_codebuild,
    {
      REGISTRY_URL     = module.ecr.ecr_url
      SERVICE          = module.ecs.service_name["be"]
      SECRET_MANAGER   = module.secret_manager.secret_ids["be"]
      ECS_CLUSTER_NAME = module.ecs.cluster_name
      ECR_URL          = module.ecr.ecr_url
      REGION           = local.project.region
      CONTAINER_NAME   = "${local.project.env}-${local.project.name}-${var.be_build_name}"
      ECR_IMAGE_TAG    = var.be_ecr_image_tag
    }
  )
  codebuild_role_arn = module.pipeline_be.codebuild_role_arn
}
