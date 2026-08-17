######################## VARIABLES ########################

#================ Project =================#
variable "project" {
  type        = map(any)
  description = "Project configuration"
}

variable "tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

#================ VPC =================#
variable "alb_vpc_id" {
  type        = string
  description = "VPC ID for the ALB"
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB"
}

#================ DNS =================#
variable "alb_dns_cert" {
  type        = string
  description = "ACM certificate ARN for the HTTPS listener"
}
