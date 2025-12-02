############################## VARIABLES ##############################

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
  default     = "admin"
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
  type    = number
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
