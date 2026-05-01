######################## ALB ########################
variable "project" {
  type = object({
    name        = string
    env         = string
    region      = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "dns_cert_arn" {
  type    = string
  default = null
}

variable "enable_https_listener" {
  type        = bool
  default     = false
  description = "Enable HTTPS listener (requires dns_cert_arn)"
}

variable "source_ingress_sg_cidr" {
  type = list(string)
}

variable "lb_name" {
  type = string
}

#----------------------- Target Group -----------------------

variable "target_groups" {
  description = "Map of target groups to create"
  type = map(object({
    name              = string
    service_port      = number
    health_check_path = string
    priority          = number
    host_header       = string
    target_type       = optional(string, "instance")
    ec2_id            = optional(string, null)
  }))
  default = {}
}

