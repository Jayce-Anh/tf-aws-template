############################ DEPENDENCE ########################

#---------ACM---------#
#Certificate for ALB
module "acm_alb" {
  source  = "../../../modules/acm"
  project = local.project
  tags    = local.tags
  domain  = var.domain_alb
  region  = local.project.region
}

#Certificate for CloudFront
module "acm_s3cf" {
  source  = "../../../modules/acm"
  project = local.project
  tags    = local.tags
  domain  = var.domain_s3cf
  region  = local.project.region
}

#---------Secret Manager---------#
# module "secret_manager" {
#   source      = "../../../modules/secret_manager"
#   project     = local.project
#   tags        = local.tags
#   secrets     = var.secrets
# } 

  #---------PARAMETER STORE---------#
# module "parameter_store" {
#   source          = "../../../modules/parameter_store"
#   project         = local.project
#   tags            = local.tags
#   source_services = var.source_services
# }

#---------ECR---------#
module "ecr" {
  source          = "../../../modules/ecr"
  project         = local.project
  tags            = local.tags
  s3_force_del    = var.ecr_force_destroy
  source_services = var.source_services
}

#---------Bastion---------#
module "bastion" {
  source                     = "../../../modules/ec2"
  project                    = local.project
  tags                       = local.tags
  enabled_eip                = var.enabled_eip
  instance_type              = var.instance_type
  instance_name              = var.instance_name
  iops                       = var.iops
  volume_size                = var.volume_size
  vpc_id                     = data.terraform_remote_state.network.outputs.vpc_id
  path_user_data             = var.path_user_data
  key_name                   = var.key_name
  subnet_id                  = data.terraform_remote_state.network.outputs.public_subnet_ids[0]

  sg_ingress = var.sg_ingress
  sg_egress = var.sg_egress
}