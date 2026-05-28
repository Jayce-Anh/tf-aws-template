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
    secret_name       = string
    use_initial_value = optional(bool, true)
    secret_data       = optional(map(string), {})
  }))
  description = "Map of secrets for Secret Manager"
}

#------------ECR------------#
variable "ecr_force_destroy" {
  type    = bool
  default = true
}
variable "source_services" {
  type = list(string)
}

#------------Bastion------------#
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
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = string
    source_security_group_id = optional(string, null)
    cidr_blocks              = optional(list(string), ["0.0.0.0/0"])
  }))
  description = "Map of ingress rules for EC2 security group"
}

variable "sg_egress" {
  type = map(object({
    from_port                = optional(number, 0)
    to_port                  = optional(number, 0)
    protocol                 = optional(string, "-1")
    description              = optional(string, "Allow outbound access")
    cidr_blocks              = optional(list(string), null)
    source_security_group_id = optional(string, null)
  }))
  description = "Map of egress rules for EC2 security group"
}

#------------External LB------------#
variable "lb_name" { type = string }
variable "source_ingress_sg_cidr" { type = list(string) }
variable "enable_https_listener" {
  type    = bool
  default = true
}
variable "alb_enable_cloudwatch" {
  type    = bool
  default = false
}
variable "target_groups" {
  type = map(object({
    name              = string
    service_port      = number
    health_check_path = string
    priority          = number
    host_header       = string
    target_type       = string
    ec2_id            = string
  }))
}

#------------CloudFront------------#
variable "service_name" { type = string }
variable "cloudfront_domain" { type = string }
variable "cloudfront_force_destroy" {
  type    = bool
  default = true
}
variable "custom_error_response" {
  type = map(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
}

#------------RDS------------#
variable "rds_name" { type = string }
variable "rds_multi_az" {
  type    = bool
  default = false
}
variable "rds_storage_type" {
  type    = string
  default = "gp3"
}
variable "rds_iops" {
  type    = number
  default = 3000
}
variable "rds_throughput" {
  type    = number
  default = 125
}
variable "rds_storage" {
  type    = number
  default = 30
}
variable "rds_max_storage" {
  type    = number
  default = 100
}
variable "rds_username" {
  type        = string
  default     = "todo"
  description = "Change this later with Secrets Manager"
  sensitive   = true
}
variable "rds_password" {
  type        = string
  default     = "password"
  description = "Change this later with Secrets Manager"
  sensitive   = true
}
variable "rds_class" {
  type    = string
  default = "db.t4g.small"
}
variable "rds_engine" { type = string }
variable "rds_engine_version" { type = string }
variable "rds_port" { type = number }
variable "rds_backup_retention_period" {
  type    = number
  default = 7
}
variable "performance_insights_retention_period" {
  type    = number
  default = 0
}
variable "rds_family" { type = string }
variable "aws_db_parameters" {
  type = map(any)
}
variable "rds_enable_cloudwatch" {
  type    = bool
  default = false
}

#------------Redis------------#
variable "redis_name" { type = string }
variable "redis_engine" { type = string }
variable "redis_engine_version" {
  type    = string
  default = "6.2"
}
variable "redis_port" {
  type    = number
  default = 6379
}
variable "redis_num_cache_nodes" {
  type        = number
  description = "Number of cache nodes in the cluster"
}
variable "redis_node_type" {
  type    = string
  default = "cache.t4g.small"
}
variable "redis_snapshot_retention_limit" {
  type    = number
  default = 1
}
variable "redis_family" { type = string }
variable "allowed_cidr_blocks_access_redis" {
  type    = list(string)
  default = []
}
variable "redis_parameters" {
  type = map(string)
  default = {
    "maxmemory-policy" = "allkeys-lru"
  }
}
variable "redis_enable_cloudwatch" {
  type    = bool
  default = false
}

#------------ECS------------#
variable "ecs_task_definitions" {
  type = map(object({
    container_name       = string
    desired_count        = number
    cpu                  = optional(number, 1024)
    memory               = optional(number, 2048)
    container_port       = number
    host_port            = number
    health_check_path    = string
    enable_load_balancer = optional(bool, true)
    load_balancer = object({
      target_group_port = number
      container_port    = number
    })
  }))
}
variable "ecs_enable_cloudwatch" {
  type    = bool
  default = false
}

#---------S3-Bucket-Pipeline---------#
variable "s3_force_del" {
  type        = bool
  default     = true
  description = "Force destroy the S3 bucket"
}

#---------FE-Pipeline---------#
variable "fe_enable_ecs_deploy" {
  type        = bool
  default     = false
  description = "Enable ECS deployment for FE"
}

variable "fe_pipeline_name" {
  type        = string
  description = "Pipeline name"
}

variable "fe_build_name" {
  type        = string
  description = "Build name"
}

variable "fe_buildspec_file" {
  type        = string
  description = "Path to the FE buildspec file"
}

variable "fe_ecr_image_tag" {
  type        = string
  description = "FE ECR image tag"
  default     = "latest"
}

variable "fe_env_vars_codebuild" {
  type        = map(any)
  description = "Environment variables for the codebuild project"
}

#---------BE-Pipeline---------#
variable "be_enable_ecs_deploy" {
  type        = bool
  default     = true
  description = "Enable ECS deployment for BE"
}

variable "be_pipeline_name" {
  type        = string
  description = "BE pipeline name"
}

variable "be_build_name" {
  type        = string
  description = "BE build name"
}

variable "be_buildspec_file" {
  type        = string
  description = "Path to the BE buildspec file"
}

variable "be_ecr_image_tag" {
  type        = string
  description = "BE ECR image tag"
  default     = "latest"
}

variable "be_env_vars_codebuild" {
  type        = map(any)
  description = "Environment variables for the BE codebuild project"
}
