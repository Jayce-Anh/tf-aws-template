variable "project" {
  type = object({
    name = string
    env = string
    region = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "redis_name" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "allowed_sg_ids_access_redis" {
  type = list(string)
}

variable "allowed_cidr_blocks_access_redis" {
  type = list(string)
}

variable "redis_parameters" {
  type        = map(string)
  description = "Custom parameters for Cache instance"
}

variable "redis_engine" {
  type = string
}

variable "redis_family" {
  type = string
}

variable "redis_node_type" {
  type = string
}

variable "redis_num_cache_nodes" {
  type = string
}

variable "redis_engine_version" {
  type = string
}

variable "redis_snapshot_retention_limit" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "enable_cloudwatch" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms and dashboard for Redis"
}

variable "cloudwatch_alarms" {
  type = object({
    cpu_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    memory_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    evictions = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    swap_usage_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    connections_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    cache_hit_rate_low = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    alarm_actions = list(string)
    ok_actions    = list(string)
  })
  default = {
    cpu_high = {
      threshold          = 75
      evaluation_periods = 2
      period             = 300
    }
    memory_high = {
      threshold          = 90
      evaluation_periods = 2
      period             = 300
    }
    evictions = {
      threshold          = 100
      evaluation_periods = 1
      period             = 300
    }
    swap_usage_high = {
      threshold          = 52428800  # 50 MB in bytes
      evaluation_periods = 2
      period             = 300
    }
    connections_high = {
      threshold          = 10000
      evaluation_periods = 2
      period             = 300
    }
    cache_hit_rate_low = {
      threshold          = 80  # 80%
      evaluation_periods = 2
      period             = 300
    }
    alarm_actions = []
    ok_actions    = []
  }
  description = "CloudWatch alarm configuration for Redis/ElastiCache"
}