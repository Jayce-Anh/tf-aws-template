################################ MAIN #################################

#---------VPC---------#
module "vpc" {
  source     = "../../modules/vpc"
  project    = local.project
  tags       = local.tags
  cidr_block = var.cidr_block
  subnet_az  = var.subnet_az
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


