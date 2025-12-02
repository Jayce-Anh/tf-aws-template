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
module "acm" {
  source  = "../../modules/acm"
  project = local.project
  tags    = local.tags
  domain  = var.domain
  region  = local.project.region
}

#---------PARAMETER STORE---------#
module "parameter_store" {
  source          = "../../modules/parameter_store"
  project         = local.project
  tags            = local.tags
  source_services = var.source_services
}

#---------EXTERNAL LB----------#
module "alb" {
  source                 = "../../modules/alb/external"
  project                = local.project
  tags                   = local.tags
  lb_name                = var.lb_name
  vpc_id                 = module.vpc.vpc_id
  dns_cert_arn           = module.acm.cert_arn
  subnet_ids             = module.vpc.public_subnet_ids
  source_ingress_sg_cidr = var.source_ingress_sg_cidr
  enable_https_listener  = var.enable_https_listener
  target_groups = {
    be = {
      name              = var.target_groups.be.name
      service_port      = var.target_groups.be.service_port
      health_check_path = var.target_groups.be.health_check_path
      priority          = var.target_groups.be.priority
      host_header       = var.target_groups.be.host_header
      ec2_id            = null # ASG will auto-register instances
      target_type       = "instance"
    }
    fe = {
      name              = var.target_groups.fe.name
      service_port      = var.target_groups.fe.service_port
      health_check_path = var.target_groups.fe.health_check_path
      priority          = var.target_groups.fe.priority
      host_header       = var.target_groups.fe.host_header
      ec2_id            = null # ASG will auto-register instances
      target_type       = "instance"
    }
  }
}


#---------APPLICATION SERVER---------#
module "ec2_instance" {
  source        = "../../modules/ec2"
  project       = local.project
  tags          = local.tags
  vpc_id        = module.vpc.vpc_id
  ami_id        = data.aws_ami.ubuntu-ami.id
  instance_type = var.instance_type
  instance_name = var.instance_name
  iops          = var.iops
  volume_size   = var.volume_size
  key_name      = var.key_name
  
  # High Availability Configuration - Multi-AZ Deployment
  enable_asg                = var.enable_asg
  subnet_ids                = module.vpc.public_subnet_ids # Deploy across all AZs
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  termination_policies      = var.termination_policies
  
  # ALB Integration for traffic distribution
  target_group_arns = [
    module.alb.tg_arns["be"],
    module.alb.tg_arns["fe"]
  ]
  
  # Auto Scaling Policy - Target Tracking (CPU-based)
  enable_cpu_scaling = var.enable_cpu_scaling
  cpu_target_value   = var.cpu_target_value
  
  # CloudWatch Metrics Collection
  enabled_metrics = var.enabled_metrics
  
  # Note: For memory and disk-based auto-scaling, install CloudWatch Agent via user_data
  # The agent will send custom metrics for:
  # - Memory usage (mem_used_percent)
  # - Disk usage (disk_used_percent)
  # Then create custom CloudWatch alarms and scaling policies based on these metrics
  
  path_user_data = var.path_user_data

  sg_ingress = {
    rule2 = {
      source_security_group_id = module.alb.lb_sg_id
    }
  }
  
  sg_egress = var.sg_egress
}

