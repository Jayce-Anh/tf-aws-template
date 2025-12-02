################################# CLOUDWATCH #######################################

#----------------------- CloudWatch Alarms  -----------------------
# High CPU Utilization Alarm (for single EC2 instance only)
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.cpu_high.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarms.cpu_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.cpu_high.threshold
  alarm_description   = "This metric monitors EC2 CPU utilization"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.ec2[0].id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}-cpu-high"
  })
}

# Status Check Failed Alarm (for single EC2 instance only)
resource "aws_cloudwatch_metric_alarm" "ec2_status_check_failed" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.status_check_failed.evaluation_periods
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarms.status_check_failed.period
  statistic           = "Maximum"
  threshold           = var.cloudwatch_alarms.status_check_failed.threshold
  alarm_description   = "This metric monitors EC2 status check failures"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.ec2[0].id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}-status-check-failed"
  })
}

# Instance Status Check Failed Alarm (for single EC2 instance only)
resource "aws_cloudwatch_metric_alarm" "ec2_instance_status_check_failed" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-instance-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.instance_status_check_failed.evaluation_periods
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarms.instance_status_check_failed.period
  statistic           = "Maximum"
  threshold           = var.cloudwatch_alarms.instance_status_check_failed.threshold
  alarm_description   = "This metric monitors EC2 instance status check failures"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.ec2[0].id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}-instance-check-failed"
  })
}

# System Status Check Failed Alarm
resource "aws_cloudwatch_metric_alarm" "ec2_system_status_check_failed" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-system-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.system_status_check_failed.evaluation_periods
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarms.system_status_check_failed.period
  statistic           = "Maximum"
  threshold           = var.cloudwatch_alarms.system_status_check_failed.threshold
  alarm_description   = "This metric monitors EC2 system status check failures"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.ec2[0].id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}-system-check-failed"
  })
}

# High Disk Read Operations Alarm
resource "aws_cloudwatch_metric_alarm" "ec2_disk_read_ops_high" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-disk-read-ops-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.disk_read_ops_high.evaluation_periods
  metric_name         = "DiskReadOps"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarms.disk_read_ops_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.disk_read_ops_high.threshold
  alarm_description   = "This metric monitors EC2 disk read operations"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.ec2[0].id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}-disk-read-ops-high"
  })
}

# High Disk Write Operations Alarm
resource "aws_cloudwatch_metric_alarm" "ec2_disk_write_ops_high" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.instance_name}-disk-write-ops-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.disk_write_ops_high.evaluation_periods
  metric_name         = "DiskWriteOps"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarms.disk_write_ops_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.disk_write_ops_high.threshold
  alarm_description   = "This metric monitors EC2 disk write operations"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.ec2[0].id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.instance_name}-disk-write-ops-high"
  })
}

#----------------------- CloudWatch Dashboard -----------------------
resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  count = var.enable_cloudwatch && !var.enable_asg ? 1 : 0
  
  dashboard_name = "${var.project.env}-${var.project.name}-${var.instance_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.ec2.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "CPU Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.ec2.id],
            [".", "StatusCheckFailed_Instance", ".", "."],
            [".", "StatusCheckFailed_System", ".", "."]
          ]
          period = 300
          stat   = "Maximum"
          region = var.project.region
          title  = "Status Checks"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.ec2.id],
            [".", "NetworkOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Network Traffic (Bytes)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "DiskReadOps", "InstanceId", aws_instance.ec2.id],
            [".", "DiskWriteOps", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Disk Operations"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "DiskReadBytes", "InstanceId", aws_instance.ec2.id],
            [".", "DiskWriteBytes", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Disk Throughput (Bytes)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkPacketsIn", "InstanceId", aws_instance.ec2.id],
            [".", "NetworkPacketsOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Network Packets"
        }
      }
    ]
  })
}

