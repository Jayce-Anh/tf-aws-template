# Example 1: Single EC2 Instance (Bastion Host)
module "bastion" {
  source        = "./modules/ec2"
  project       = local.project
  tags          = local.tags
  vpc_id        = local.network.vpc_id
  enabled_eip   = true
  instance_type = "t3a.small"
  instance_name = "bastion"
  iops          = 3000
  volume_size   = 30
  key_name      = "lab-jayce"
  subnet_id     = local.network.public_subnet_ids[0]
  
  # Single EC2 Instance (not ASG)
  enable_asg    = false
  
  path_user_data = "${path.root}/scripts/user_data/user_data.sh"

  sg_ingress = {
    rule1 = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Connect to bastion"
    },
    rule2 = {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Connect to RDS MySQL"
    }
  }

  sg_egress = {
    all = {
      description = "Allow all outbound"
    }
  }
}

# Example 2: Auto Scaling Group with Target Tracking (Recommended for Production)
module "app_servers_asg" {
  source        = "./modules/ec2"
  project       = local.project
  tags          = local.tags
  instance_type = "t3.medium"
  instance_name = "app-server"
  iops          = 3000
  volume_size   = 50
  key_name      = "lab-jayce"
  vpc_id        = local.network.vpc_id

  # Enable Auto Scaling Group
  enable_asg                = true
  subnet_ids                = local.network.private_subnet_ids # Deploy in private subnets
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 5
  health_check_type         = "ELB" # Use ELB health checks for ALB integration
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance", "Default"]

  # ALB Integration
  target_group_arns = [module.alb.target_group_arn]

  # Auto Scaling - Target Tracking (Recommended)
  enable_cpu_scaling = true
  cpu_target_value   = 70 # Scale when CPU reaches 70%

  # CloudWatch Metrics
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  path_user_data = "${path.root}/scripts/user_data/app_server_init.sh"

  sg_ingress = {
    http = {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "HTTP from ALB"
      source_security_group_id = module.alb.lb_sg_id
    },
    https = {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "HTTPS from ALB"
      source_security_group_id = module.alb.lb_sg_id
    }
  }

  sg_egress = {
    all_traffic = {
      description = "Allow all outbound traffic"
    }
  }
}

# Example 3: Auto Scaling Group with Step Scaling (Custom Thresholds)
module "worker_servers_asg" {
  source        = "./modules/ec2"
  project       = local.project
  tags          = local.tags
  instance_type = "t3.small"
  instance_name = "worker"
  iops          = 3000
  volume_size   = 30
  key_name      = "lab-jayce"
  vpc_id        = local.network.vpc_id

  # Enable Auto Scaling Group
  enable_asg                = true
  subnet_ids                = local.network.private_subnet_ids
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_type         = "EC2"
  health_check_grace_period = 180

  # Auto Scaling - Step Scaling (More control)
  enable_cpu_scaling = false # Disable target tracking
  enable_step_scaling = true

  # Scale Up Configuration
  scale_up_adjustment        = 2 # Add 2 instances
  scale_up_cooldown          = 300
  scale_up_threshold         = 80 # Scale up at 80% CPU
  scale_up_evaluation_periods = 2
  scale_up_period            = 300

  # Scale Down Configuration
  scale_down_adjustment        = -1 # Remove 1 instance
  scale_down_cooldown          = 300
  scale_down_threshold         = 20 # Scale down at 20% CPU
  scale_down_evaluation_periods = 2
  scale_down_period            = 300

  path_user_data = "${path.root}/scripts/user_data/worker_init.sh"

  sg_ingress = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access from bastion"
      source_security_group_id = module.bastion.ec2_sg_id
    }
  }

  sg_egress = {
    all_traffic = {
      description = "Allow all outbound traffic"
    }
  }
}