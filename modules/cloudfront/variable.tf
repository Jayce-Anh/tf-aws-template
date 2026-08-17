########################### VARIABLES ###########################

#================ Project =================#
variable "project" {
  type        = map(any)
  description = "Project metadata (env, name, region, account_ids)"
}

variable "tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

#============== Cloudfront ===============#
variable "cf_alb_dns_name" {
  type        = string
  description = "DNS name of the ALB used as /api/* origin"
}

variable "cf_hosted_zone_id" {
  type        = string
  description = "Route53 hosted zone ID for CloudFront ACM validation and alias records"
}
