###################### OUTPUTS ######################

#---------VPC---------#
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

#------------ EKS---------#
output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}

output "eks_cluster_arn" {
  value = module.eks.eks_cluster_arn
}

output "eks_cluster_version" {
  value = module.eks.eks_cluster_version
}

output "alb_controller_role_arn" {
  value = module.eks.alb_controller_role_arn
}