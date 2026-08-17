############################# ROUTE53 VARIABLE ##############################

#=============== Project ================#
variable "project" {
  type        = map(any)
  description = "Project configuration"
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to the hosted zone"
}

#=============== Route53 ================#
variable "r53_domain_name" {
  type        = string
  description = "The domain name for the hosted zone"
}
