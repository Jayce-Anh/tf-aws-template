############################ APPLICATION ########################

#-----------External LB------------#
module "alb" {
  source                 = "../../../modules/alb/external"
  project                = local.project
  tags                   = local.tags
  lb_name                = var.lb_name
  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  dns_cert_arn           = data.terraform_remote_state.dependence.outputs.acm_alb_arn
  enable_https_listener  = var.enable_https_listener
  subnet_ids             = data.terraform_remote_state.network.outputs.public_subnet_ids
  source_ingress_sg_cidr = var.source_ingress_sg_cidr
  enable_cloudwatch      = var.alb_enable_cloudwatch

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
  source                = "../../../modules/cloudfront"
  project               = local.project
  tags                  = local.tags
  service_name          = var.service_name
  cf_cert_arn           = data.terraform_remote_state.dependence.outputs.acm_s3cf_arn
  s3_force_del          = var.cloudfront_force_destroy
  cloudfront_domain     = var.cloudfront_domain
  custom_error_response = var.custom_error_response
}

#-----------RDS------------#
module "rds" {
  source     = "../../../modules/database/rds"
  project    = local.project
  tags       = local.tags
  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  rds_name   = var.rds_name
  db_name    = local.project.name
  multi_az   = var.rds_multi_az
  allowed_sg_ids_access_rds = [
    data.terraform_remote_state.dependence.outputs.bastion_sg_id,
    module.ecs.ecs_tasks_sg_id,
  ]
  rds_storage_type = var.rds_storage_type
  rds_iops         = var.rds_iops
  rds_throughput   = var.rds_throughput

  rds_storage     = var.rds_storage
  rds_max_storage = var.rds_max_storage

  # Credentials for RDS creation (also store these in Secrets Manager manually)
  # rds_username = local.be_secrets["DB_USERNAME"]
  # rds_password = local.be_secrets["DB_PASSWORD"]

  # rds_username = data.terraform_remote_state.dependence.outputs.secret_ids["be"]["DB_USERNAME"]
  # rds_password = data.terraform_remote_state.dependence.outputs.secret_ids["be"]["DB_PASSWORD"]

  rds_password = "password"
  rds_username = "todo"

  rds_class                             = var.rds_class
  rds_engine                            = var.rds_engine
  rds_engine_version                    = var.rds_engine_version
  rds_port                              = var.rds_port
  rds_backup_retention_period           = var.rds_backup_retention_period
  performance_insights_retention_period = var.performance_insights_retention_period
  enable_cloudwatch                     = var.rds_enable_cloudwatch

  rds_family        = var.rds_family
  aws_db_parameters = var.aws_db_parameters
}

#------------Redis------------#
module "redis" {
  source                           = "../../../modules/database/redis"
  project                          = local.project
  tags                             = local.tags
  vpc_id                           = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids                       = data.terraform_remote_state.network.outputs.private_subnet_ids
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
  redis_parameters     = var.redis_parameters
  enable_cloudwatch    = var.redis_enable_cloudwatch
}

#-----------ECS------------#
module "ecs" {
  source           = "../../../modules/ecs"
  project          = local.project
  tags             = local.tags
  vpc_id           = data.terraform_remote_state.network.outputs.vpc_id
  lb_sg_id         = module.alb.lb_sg_id
  target_group_arn = module.alb.tg_arns["be"]
  subnets          = data.terraform_remote_state.network.outputs.private_subnet_ids
  enable_cloudwatch = var.ecs_enable_cloudwatch
  task_definitions = {
    "be" = {
      container_name       = var.ecs_task_definitions.be.container_name
      # Use the first account ID from the project configuration
      container_image      = "${local.project.account_ids[0]}.dkr.ecr.${local.project.region}.amazonaws.com/${data.terraform_remote_state.dependence.outputs.ecr_name}:latest"
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