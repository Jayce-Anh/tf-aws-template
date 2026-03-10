######################### VARIABLES #########################

#------------VPC------------#
variable "cidr_block" { type = string }

variable "subnet_az" {
  type = map(object({
    az_index             = number
    public_subnet_count  = number
    private_subnet_count = number
  }))
  description = "Map of AZ configurations with subnet counts"
}

#------------EKS------------#
variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_version" {
  type        = string
  description = "Kubernetes version for EKS cluster"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enable private API server endpoint"
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable public API server endpoint"
  default     = false
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDR blocks that can access the public API server endpoint"
  default     = null
}

variable "eks_sg_ingress" {
  description = "Security group ingress rules for EKS cluster"
  type = object({
    ingress_rules = optional(map(object({
      from_port                = number
      to_port                  = number
      protocol                 = string
      cidr_blocks             = optional(list(string))
      source_security_group_id = optional(string)
      self                    = optional(bool)
      description             = optional(string)
    })), {})
  })
}

variable "node_groups" {
  description = "Map of EKS node group configurations"
  type = map(object({
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_type  = optional(string)
    instance_types = optional(list(string))
    capacity_type  = optional(string, "ON_DEMAND")
    disk_size      = optional(number, 20)
    disk_type      = optional(string, "gp3")
    ami_type       = optional(string, "AL2023_x86_64_STANDARD")
    key_name       = optional(string)
    labels         = optional(map(string))
    ingress_rules  = optional(map(object({
      from_port                = number
      to_port                  = number
      protocol                 = string
      cidr_blocks             = optional(list(string))
      source_security_group_id = optional(string)
      self                    = optional(bool)
      description             = optional(string)
    })), {})
    tags = optional(map(string))
  }))
}

variable "addons" {
  description = "List of EKS addons to install"
  type = list(object({
    name    = string
    version = optional(string)
  }))
  default = []
}
