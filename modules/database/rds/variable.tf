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

variable "rds_name" {
  type = string
}

variable "multi_az" {
  description = "If set to true, RDS instance is multi-AZ"
  type        = bool
}

variable "rds_class" {
  type = string
}

variable "rds_storage" {
  type = string
}

variable "rds_max_storage" {
  type = string
}

variable "rds_storage_type" {
  type = string
}

variable "rds_iops" {
  type = number
}

variable "rds_throughput" {
  type = number
}

variable "rds_family" {
  type = string
}

variable "rds_engine" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

variable "rds_port" {
  type = string
}
variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
  sensitive = true
}

variable "rds_backup_retention_period" {
  type = number
}

variable "performance_insights_retention_period" {
  type = number
}

variable "aws_db_parameters" {
  type        = map(string)
  description = "Custom parameters for RDS instance"
}

variable "allowed_sg_ids_access_rds" {
  type = list(string)
}

variable "db_name" {
  type = string
  description = "Name of the database when creating the instance"
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
  description = "Enable CloudWatch alarms and dashboard for RDS"
}

variable "cloudwatch_alarms" {
  type = object({
    cpu_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    connections_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    disk_queue_depth = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    free_storage_low = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    read_latency_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    write_latency_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    freeable_memory_low = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    alarm_actions = list(string)
    ok_actions    = list(string)
  })
  default = {
    cpu_high = {
      threshold          = 80
      evaluation_periods = 2
      period             = 300
    }
    connections_high = {
      threshold          = 100
      evaluation_periods = 2
      period             = 300
    }
    disk_queue_depth = {
      threshold          = 10
      evaluation_periods = 2
      period             = 300
    }
    free_storage_low = {
      threshold          = 10737418240  # 10 GB in bytes
      evaluation_periods = 1
      period             = 300
    }
    read_latency_high = {
      threshold          = 0.1  # 100ms
      evaluation_periods = 2
      period             = 300
    }
    write_latency_high = {
      threshold          = 0.1  # 100ms
      evaluation_periods = 2
      period             = 300
    }
    freeable_memory_low = {
      threshold          = 268435456  # 256 MB in bytes
      evaluation_periods = 2
      period             = 300
    }
    alarm_actions = []
    ok_actions    = []
  }
  description = "CloudWatch alarm configuration for RDS instance"
}