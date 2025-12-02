############################### OUTPUTS ###############################

#------------ACM------------#
output "acm_alb_arn" {
  value = module.acm_alb.cert_arn
}

output "acm_s3cf_arn" {
  value = module.acm_s3cf.cert_arn
}

# #------------Secret Manager------------#
# output "secret_names" {
#   value = module.secret_manager.secret_names
# }

# output "secret_ids" {
#   value = module.secret_manager.secret_ids
# }

#------------Parameter Store------------#
# output "parameter_name" {
#   value = module.parameter_store.parameter_name
# }

#------------ECR------------#
output "ecr_url" {
  value = module.ecr.ecr_url
}

output "ecr_name" {
  value = module.ecr.ecr_name
}

#-------------Bastion------------#
output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "bastion_id" {
  value = module.bastion.ec2_id
}

output "bastion_sg_id" {
  value = module.bastion.ec2_sg_id
}
