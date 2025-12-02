######################## ALB ########################
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

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "dns_cert_arn" {
  type = string
  default = null
}

variable "enable_https_listener" {
  type = bool
  default = false
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
    name             = string
    service_port     = number
    health_check_path = string
    priority         = number
    host_header      = string
    target_type      = optional(string, "instance")
    ec2_id           = optional(string, null)
  }))
  default = {}
}

variable "enable_cloudwatch" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms and dashboard for ALB"
}

variable "cloudwatch_alarms" {
  type = object({
    unhealthy_targets = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    response_time_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    http_5xx_errors = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    http_4xx_errors = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    request_count_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    alarm_actions = list(string)
    ok_actions    = list(string)
  })
  default = {
    unhealthy_targets = {
      threshold          = 1
      evaluation_periods = 2
      period             = 60
    }
    response_time_high = {
      threshold          = 2  # 2 seconds
      evaluation_periods = 2
      period             = 300
    }
    http_5xx_errors = {
      threshold          = 10
      evaluation_periods = 1
      period             = 300
    }
    http_4xx_errors = {
      threshold          = 50
      evaluation_periods = 2
      period             = 300
    }
    request_count_high = {
      threshold          = 10000
      evaluation_periods = 1
      period             = 300
    }
    alarm_actions = []
    ok_actions    = []
  }
  description = "CloudWatch alarm configuration for ALB"
}


