################################# CLOUDWATCH #######################################

#----------------------- CloudWatch Alarms -----------------------
# High CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  for_each = var.enable_cloudwatch ? var.task_definitions : {}

  alarm_name          = "${var.project.env}-${var.project.name}-${each.key}-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.cpu_high.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cloudwatch_alarms.cpu_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.cpu_high.threshold
  alarm_description   = "This metric monitors ECS CPU utilization for ${each.key}"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.service[each.key].name
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${each.key}-ecs-cpu-high"
  })
}

# High Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  for_each = var.enable_cloudwatch ? var.task_definitions : {}

  alarm_name          = "${var.project.env}-${var.project.name}-${each.key}-ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.memory_high.evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.cloudwatch_alarms.memory_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.memory_high.threshold
  alarm_description   = "This metric monitors ECS memory utilization for ${each.key}"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.service[each.key].name
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${each.key}-ecs-memory-high"
  })
}

# Low Running Task Count Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_task_count_low" {
  for_each = var.enable_cloudwatch ? var.task_definitions : {}

  alarm_name          = "${var.project.env}-${var.project.name}-${each.key}-ecs-task-count-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.task_count_low.evaluation_periods
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = var.cloudwatch_alarms.task_count_low.period
  statistic           = "Average"
  threshold           = each.value.desired_count
  alarm_description   = "This metric monitors running ECS task count for ${each.key}"
  treat_missing_data  = "breaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.service[each.key].name
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${each.key}-ecs-task-count-low"
  })
}

#----------------------- CloudWatch Dashboard -----------------------
resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  count = var.enable_cloudwatch ? 1 : 0
  
  dashboard_name = "${var.project.env}-${var.project.name}-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = concat(
      # CPU Utilization widgets
      [for key, task in var.task_definitions : {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", aws_ecs_service.service[key].name, "ClusterName", aws_ecs_cluster.ecs_cluster.name]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "${key} - CPU Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }],
      # Memory Utilization widgets
      [for key, task in var.task_definitions : {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ServiceName", aws_ecs_service.service[key].name, "ClusterName", aws_ecs_cluster.ecs_cluster.name]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "${key} - Memory Utilization"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }],
      # Running Task Count widgets
      [for key, task in var.task_definitions : {
        type = "metric"
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", aws_ecs_service.service[key].name, "ClusterName", aws_ecs_cluster.ecs_cluster.name]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "${key} - Running Tasks"
        }
      }]
    )
  })
}

