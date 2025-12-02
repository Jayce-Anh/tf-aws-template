################################### OUTPUTS ###############################

#--------- VPC ---------#
output "vpc_id" {
  value = module.vpc.vpc_id
}

#--------- ACM ---------#
output "acm" {
  value = module.acm.cert_arn
}

#--------- PARAMETER STORE ---------#
output "parameter_store_name" {
  value = module.parameter_store.parameter_name
}

#--------- EC2 ------------#
output "ec2_id" {
  value = module.ec2_instance.ec2_id
}

#------------ ALB ------------#
output "alb_arn" {
  value = module.alb.lb_arn
}