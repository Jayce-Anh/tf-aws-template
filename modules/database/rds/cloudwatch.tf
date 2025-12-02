################################# CLOUDWATCH ALARMS #######################################

#----------------------- CloudWatch Alarms -----------------------
# High CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.cpu_high.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.cpu_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.cpu_high.threshold
  alarm_description   = "This metric monitors RDS CPU utilization"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-cpu-high"
  })
}

# High Database Connections Alarm
resource "aws_cloudwatch_metric_alarm" "rds_connections_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.connections_high.evaluation_periods
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.connections_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.connections_high.threshold
  alarm_description   = "This metric monitors RDS database connections"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-connections-high"
  })
}

# High Disk Queue Depth Alarm
resource "aws_cloudwatch_metric_alarm" "rds_disk_queue_depth" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-disk-queue-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.disk_queue_depth.evaluation_periods
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.disk_queue_depth.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.disk_queue_depth.threshold
  alarm_description   = "This metric monitors RDS disk queue depth"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-disk-queue-high"
  })
}

# Low Free Storage Space Alarm
resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.free_storage_low.evaluation_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.free_storage_low.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.free_storage_low.threshold
  alarm_description   = "This metric monitors RDS free storage space"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-storage-low"
  })
}

# High Read Latency Alarm
resource "aws_cloudwatch_metric_alarm" "rds_read_latency_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-read-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.read_latency_high.evaluation_periods
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.read_latency_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.read_latency_high.threshold
  alarm_description   = "This metric monitors RDS read latency"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-read-latency-high"
  })
}

# High Write Latency Alarm
resource "aws_cloudwatch_metric_alarm" "rds_write_latency_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-write-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.write_latency_high.evaluation_periods
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.write_latency_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.write_latency_high.threshold
  alarm_description   = "This metric monitors RDS write latency"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-write-latency-high"
  })
}

# Low Freeable Memory Alarm
resource "aws_cloudwatch_metric_alarm" "rds_freeable_memory_low" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.rds_name}-memory-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.freeable_memory_low.evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = var.cloudwatch_alarms.freeable_memory_low.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.freeable_memory_low.threshold
  alarm_description   = "This metric monitors RDS freeable memory"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.rds_name}-memory-low"
  })
}

#----------------------- Dashboard for RDS -----------------------
resource "aws_cloudwatch_dashboard" "rds_dashboard" {
  count = var.enable_cloudwatch ? 1 : 0
  
  dashboard_name = "${var.project.env}-${var.project.name}-${var.rds_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.db.id]
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
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", aws_db_instance.db.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Database Connections"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", aws_db_instance.db.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Free Storage Space (Bytes)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", aws_db_instance.db.id],
            [".", "WriteLatency", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Read/Write Latency (Seconds)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", aws_db_instance.db.id],
            [".", "WriteIOPS", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Read/Write IOPS"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", aws_db_instance.db.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Freeable Memory (Bytes)"
        }
      }
    ]
  })
}

