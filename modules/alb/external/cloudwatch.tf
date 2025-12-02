################################# CLOUDWATCH ALARMS #######################################

#----------------------- CloudWatch Alarms -----------------------
# Unhealthy Target Count Alarm
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "${var.project.env}-${var.project.name}-${var.lb_name}-unhealthy-targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.unhealthy_targets.evaluation_periods
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.cloudwatch_alarms.unhealthy_targets.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.unhealthy_targets.threshold
  alarm_description   = "This metric monitors unhealthy targets in ALB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.lb.arn_suffix
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.lb_name}-unhealthy-targets"
  })
}

# High Response Time Alarm
resource "aws_cloudwatch_metric_alarm" "alb_response_time_high" {
  alarm_name          = "${var.project.env}-${var.project.name}-${var.lb_name}-response-time-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.response_time_high.evaluation_periods
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = var.cloudwatch_alarms.response_time_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.response_time_high.threshold
  alarm_description   = "This metric monitors ALB target response time"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.lb.arn_suffix
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.lb_name}-response-time-high"
  })
}

# High HTTP 5xx Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.lb_name}-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.http_5xx_errors.evaluation_periods
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.cloudwatch_alarms.http_5xx_errors.period
  statistic           = "Sum"
  threshold           = var.cloudwatch_alarms.http_5xx_errors.threshold
  alarm_description   = "This metric monitors HTTP 5xx errors from targets"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.lb.arn_suffix
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.lb_name}-5xx-errors"
  })
}

# High HTTP 4xx Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.lb_name}-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.http_4xx_errors.evaluation_periods
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.cloudwatch_alarms.http_4xx_errors.period
  statistic           = "Sum"
  threshold           = var.cloudwatch_alarms.http_4xx_errors.threshold
  alarm_description   = "This metric monitors HTTP 4xx errors from targets"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.lb.arn_suffix
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.lb_name}-4xx-errors"
  })
}

# High Request Count Alarm
resource "aws_cloudwatch_metric_alarm" "alb_request_count_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.lb_name}-request-count-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.request_count_high.evaluation_periods
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.cloudwatch_alarms.request_count_high.period
  statistic           = "Sum"
  threshold           = var.cloudwatch_alarms.request_count_high.threshold
  alarm_description   = "This metric monitors high request count on ALB"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_lb.lb.arn_suffix
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.lb_name}-request-count-high"
  })
}

#----------------------- CloudWatch Dashboard -----------------------
resource "aws_cloudwatch_dashboard" "alb_dashboard" {
  count = var.enable_cloudwatch ? 1 : 0
  
  dashboard_name = "${var.project.env}-${var.project.name}-${var.lb_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", aws_lb.lb.arn_suffix],
            [".", "UnHealthyHostCount", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Target Health"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.lb.arn_suffix]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Target Response Time (Seconds)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.lb.arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.project.region
          title  = "Request Count"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", aws_lb.lb.arn_suffix],
            [".", "HTTPCode_Target_4XX_Count", ".", "."],
            [".", "HTTPCode_Target_5XX_Count", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = var.project.region
          title  = "HTTP Response Codes"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", aws_lb.lb.arn_suffix],
            [".", "NewConnectionCount", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = var.project.region
          title  = "Connection Count"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", aws_lb.lb.arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.project.region
          title  = "Processed Bytes"
        }
      }
    ]
  })
}

