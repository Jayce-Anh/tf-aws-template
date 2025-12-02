#----------------Project------------------#
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

#---------------------EC2 instance---------------------#
variable "ami_id" {
  type        = string
  default     = null
  description = "AMI ID for EC2 instance (if null, uses Ubuntu 22.04 LTS)"
}

variable "instance_type" {
  default = "t3.micro"
  type    = string
}

variable "iops" {
  type = number
}
variable "volume_size" {
  type = number
}

variable "enabled_eip" {
  type    = bool
  default = true
  description = "Attach Elastic IP to single EC2 instance"
}

variable "instance_name" {
  type = string
}

variable "subnet_id" {
  type        = string
  default     = null
  nullable    = true
  description = "Subnet ID for single EC2 instance (not used if enable_asg = true)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EC2 instance will be created"
}

variable "alb_sg_id" {
  type        = string
  default     = "" # empty string means no ALB security group
  description = "Security group ID of ALB (optional)"
}

# variable "path_public_key" {
#   type = string
#   description = "Path to import public key"
# }

variable "path_user_data" {
  type = string
  description = "Path to user data"
}

variable "key_name" {
  type = string
  description = "Name of the key pair"
}

# variable "path_public_key" {
#   type = string
#   description = "Path to public key"
# }

variable "sg_ingress" {
  type = map(object({
    from_port      = number
    to_port        = number
    protocol       = string
    description    = string
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
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
    source_security_group_id = optional(string, null)
  }))
  description = "Map of egress rules for EC2 security group"
}

variable "enable_cloudwatch" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms and dashboard for EC2"
}

variable "cloudwatch_alarms" {
  type = object({
    cpu_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    status_check_failed = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    instance_status_check_failed = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    system_status_check_failed = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    disk_read_ops_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    disk_write_ops_high = object({
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
    status_check_failed = {
      threshold          = 0
      evaluation_periods = 2
      period             = 60
    }
    instance_status_check_failed = {
      threshold          = 0
      evaluation_periods = 2
      period             = 60
    }
    system_status_check_failed = {
      threshold          = 0
      evaluation_periods = 2
      period             = 60
    }
    disk_read_ops_high = {
      threshold          = 1000
      evaluation_periods = 2
      period             = 300
    }
    disk_write_ops_high = {
      threshold          = 1000
      evaluation_periods = 2
      period             = 300
    }
    alarm_actions = []
    ok_actions    = []
  }
  description = "CloudWatch alarm configuration for EC2 instance"
}

#---------------------Auto Scaling Group---------------------#
variable "enable_asg" {
  type        = bool
  default     = false
  description = "Enable Auto Scaling Group (true) or deploy single EC2 instance (false)"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs for ASG to deploy instances across multiple AZs (required if enable_asg = true)"
}

variable "desired_capacity" {
  type        = number
  default     = 1
  description = "Desired number of instances in ASG"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "Maximum number of instances in ASG"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum number of instances in ASG"
}

variable "health_check_type" {
  type        = string
  default     = "EC2"
  description = "Health check type for ASG (EC2 or ELB)"
  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "Health check type must be either EC2 or ELB"
  }
}

variable "health_check_grace_period" {
  type        = number
  default     = 300
  description = "Time (in seconds) after instance launch before health checks start"
}

variable "termination_policies" {
  type        = list(string)
  default     = ["Default"]
  description = "List of policies to use for instance termination"
}

variable "target_group_arns" {
  type        = list(string)
  default     = null
  description = "List of target group ARNs to attach to ASG (for ALB integration)"
}

variable "enabled_metrics" {
  type = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  description = "List of metrics to enable for ASG"
}

variable "wait_for_capacity_timeout" {
  type        = string
  default     = "10m"
  description = "Maximum time to wait for desired capacity to be reached"
}

#---------------------Auto Scaling Policy---------------------#
variable "enable_cpu_scaling" {
  type        = bool
  default     = true
  description = "Enable target tracking scaling policy based on CPU utilization"
}

variable "cpu_target_value" {
  type        = number
  default     = 70
  description = "Target CPU utilization percentage for target tracking scaling"
}

variable "enable_step_scaling" {
  type        = bool
  default     = false
  description = "Enable step scaling policies (scale up/down based on CloudWatch alarms)"
}

variable "scale_up_adjustment" {
  type        = number
  default     = 1
  description = "Number of instances to add when scaling up"
}

variable "scale_up_cooldown" {
  type        = number
  default     = 300
  description = "Cooldown period (in seconds) after scaling up"
}

variable "scale_up_threshold" {
  type        = number
  default     = 80
  description = "CPU utilization threshold to trigger scale up"
}

variable "scale_up_evaluation_periods" {
  type        = number
  default     = 2
  description = "Number of periods to evaluate before scaling up"
}

variable "scale_up_period" {
  type        = number
  default     = 300
  description = "Period (in seconds) for scale up evaluation"
}

variable "scale_down_adjustment" {
  type        = number
  default     = -1
  description = "Number of instances to remove when scaling down"
}

variable "scale_down_cooldown" {
  type        = number
  default     = 300
  description = "Cooldown period (in seconds) after scaling down"
}

variable "scale_down_threshold" {
  type        = number
  default     = 20
  description = "CPU utilization threshold to trigger scale down"
}

variable "scale_down_evaluation_periods" {
  type        = number
  default     = 2
  description = "Number of periods to evaluate before scaling down"
}

variable "scale_down_period" {
  type        = number
  default     = 300
  description = "Period (in seconds) for scale down evaluation"
}

