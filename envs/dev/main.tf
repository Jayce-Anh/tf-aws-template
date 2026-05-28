################################ MAIN #################################

#---------VPC---------#
module "vpc" {
  source     = "../../modules/vpc"
  project    = local.project
  tags       = local.tags
  cidr_block = var.cidr_block
  subnet_az  = var.subnet_az
}

#---------EC2---------#
module "ec2_instance" {
  source         = "../../modules/ec2"
  project        = local.project
  tags           = local.tags
  vpc_id         = module.vpc.vpc_id
  enabled_eip    = true
  instance_type  = "t3a.small"
  instance_name  = "test"
  iops           = 3000
  volume_size    = 30
  key_name       = "lab-jayce"
  subnet_id      = module.vpc.public_subnet_ids[0]
  enable_asg     = false
  path_user_data = "${path.root}/scripts/user_data/user_data.sh"

  sg_ingress = {
    rule1 = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Connect to bastion"
    }
  }
}

#---------ECR---------#
module "ecr" {
  source          = "../../modules/ecr"
  project         = local.project
  tags            = local.tags
  source_services = ["positon-simulator", "position-tracker", "queue", "webapp", "api-gateway"]
  s3_force_del    = true
}

#---------Secret Manager--------#
module "secret_manager" {
  source  = "../../modules/secret_manager"
  project = local.project
  tags    = local.tags
  secrets = {
    api_gateway = {
      secret_name       = "api-gateway"
      use_initial_value = true
    }
    webapp = {
      secret_name       = "webapp"
      use_initial_value = true
    }
    position_tracker = {
      secret_name       = "position-tracker"
      use_initial_value = true
    }
    position_simulator = {
      secret_name       = "position-simulator"
      use_initial_value = true
    }
    queue = {
      secret_name       = "queue"
      use_initial_value = true
    }
  }
}

#---------EKS---------#
module "eks" {
  source                       = "../../modules/eks/node_group"
  project                      = local.project
  tags                         = local.tags
  eks_name                     = var.eks_name
  eks_version                  = var.eks_version
  eks_subnet                   = module.vpc.public_subnet_ids
  eks_vpc                      = module.vpc.vpc_id
  endpoint_private_access      = var.endpoint_private_access
  endpoint_public_access       = var.endpoint_public_access
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs
  eks_sg_ingress               = var.eks_sg_ingress
  addons                       = var.addons

  node_groups = {
    for key, config in var.node_groups : key => merge(config, {
      subnet_ids = module.vpc.public_subnet_ids
    })
  }
}
