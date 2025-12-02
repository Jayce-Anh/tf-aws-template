variable "project" {
  type = object({
    name = string
    env  = string
    region = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "lb_sg_id" {
  description = "Load balancer security group id"
  type = string
}

variable "target_group_arn" {}
variable "vpc_id" {}
variable "network_mode" {
  type = string
  default = "awsvpc"
}

variable "subnets" {
  type = list(string)
  description = "Subnets for ECS service"
}

variable "containerInsights" {
  type = string
  default = "disabled"
}

variable "task_definitions" {
  type  = map(object({
    container_name = string
    container_image = string 
    desired_count = number
    cpu = number
    memory = number
    container_port = number
    host_port = number
    health_check_path = string
    enable_load_balancer = bool
    load_balancer = optional(object({
      target_group_port = number
      container_port  = number
    }))
  }))
}

variable "log_retention" {
  type = number
  default = 14
}

variable "enable_cloudwatch" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms and dashboard for ECS"
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
    task_count_low = object({
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
    memory_high = {
      threshold          = 80
      evaluation_periods = 2
      period             = 300
    }
    task_count_low = {
      evaluation_periods = 1
      period             = 60
    }
    alarm_actions = []
    ok_actions    = []
  }
  description = "CloudWatch alarm configuration for ECS services"
}