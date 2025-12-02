####################### AUTO SCALING GROUP #######################
resource "aws_autoscaling_group" "asg" {
  count                     = var.enable_asg ? 1 : 0
  name                      = "${var.project.env}-${var.project.name}-${var.instance_name}-asg"
  vpc_zone_identifier       = var.subnet_ids
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  force_delete              = true
  termination_policies      = var.termination_policies

  launch_template {
    id      = aws_launch_template.launch_template[0].id
    version = aws_launch_template.launch_template[0].latest_version
  }

  # Attach to target group if provided (for ALB integration)
  target_group_arns = var.target_group_arns

  # Enable CloudWatch metrics
  enabled_metrics = var.enabled_metrics

  # Wait for capacity timeout
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  # Tags
  tag {
    key                 = "Name"
    value               = "${var.project.env}-${var.project.name}-${var.instance_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.project.env
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project.name
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

# Auto Scaling Policy - Target Tracking (CPU)
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  count                  = var.enable_asg && var.enable_cpu_scaling ? 1 : 0
  name                   = "${var.project.env}-${var.project.name}-${var.instance_name}-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.asg[0].name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}

# Auto Scaling Policy - Scale Up
resource "aws_autoscaling_policy" "scale_up" {
  count                  = var.enable_asg && var.enable_step_scaling ? 1 : 0
  name                   = "${var.project.env}-${var.project.name}-${var.instance_name}-scale-up"
  scaling_adjustment     = var.scale_up_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_up_cooldown
  autoscaling_group_name = aws_autoscaling_group.asg[0].name
}

# Auto Scaling Policy - Scale Down
resource "aws_autoscaling_policy" "scale_down" {
  count                  = var.enable_asg && var.enable_step_scaling ? 1 : 0
  name                   = "${var.project.env}-${var.project.name}-${var.instance_name}-scale-down"
  scaling_adjustment     = var.scale_down_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_down_cooldown
  autoscaling_group_name = aws_autoscaling_group.asg[0].name
}

# CloudWatch Alarm - High CPU for Scale Up
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count               = var.enable_asg && var.enable_step_scaling ? 1 : 0
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.scale_up_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.scale_up_period
  statistic           = "Average"
  threshold           = var.scale_up_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg[0].name
  }

  alarm_description = "This metric monitors ec2 cpu utilization for scale up"
  alarm_actions     = [aws_autoscaling_policy.scale_up[0].arn]
}

# CloudWatch Alarm - Low CPU for Scale Down
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count               = var.enable_asg && var.enable_step_scaling ? 1 : 0
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.scale_down_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.scale_down_period
  statistic           = "Average"
  threshold           = var.scale_down_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg[0].name
  }

  alarm_description = "This metric monitors ec2 cpu utilization for scale down"
  alarm_actions     = [aws_autoscaling_policy.scale_down[0].arn]
}
