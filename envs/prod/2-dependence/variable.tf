############################## VARIABLES ##############################

#------------ACM------------#
variable "domain_alb" { type = string }
variable "domain_s3cf" { type = string }
variable "region_s3cf" {
  type    = string
  default = "us-east-1"
}

#------------Secret Manager------------#
variable "secrets" {
  type = map(object({
    secret_name           = string
    use_initial_value     = optional(bool, true)
    secret_data           = optional(map(string), {})
  }))
  description = "Map of secrets for Secret Manager"
}

#------------Parameter Store------------#
# variable "parameter_store_services" {
#   type = list(string)
# }

#------------ECR------------#
variable "ecr_force_destroy" {
  type    = bool
  default = true
}
variable "source_services" {
  type = list(string)
}
#------------Bastion------------#
variable "ami_id" {
  type = string
  default = data.aws_ami.ubuntu-ami.id
  description = "AMI ID for EC2 instance"
}
variable "enabled_eip" {
  type    = bool
  default = true
}
variable "instance_type" { type = string }
variable "instance_name" {
  type    = string
  default = "bastion"
}
variable "iops" {
  type    = number
  default = 3000
}
variable "volume_size" {
  type    = number
  default = 30
}
variable "path_user_data" { type = string }
variable "key_name" { type = string }
variable "source_ingress_ec2_sg_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks allowed to access the bastion EC2 instance"
}
variable "sg_ingress" {
  type = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
      source_security_group_id = optional(string, null)
      cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  }))
  description = "Map of ingress rules for EC2 security group"
}

variable "sg_egress" {
  type = map(object({
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    protocol    = optional(string, "-1")
    description = optional(string, "Allow outbound access")
    cidr_blocks = optional(list(string), null)
    source_security_group_id = optional(string, null)
  }))
  description = "Map of egress rules for EC2 security group"
}

