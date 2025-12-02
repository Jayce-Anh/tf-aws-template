################################# CLOUDWATCH #######################################

#----------------------- CloudWatch Alarms -----------------------
# High CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "redis_cpu_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.redis_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.cpu_high.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.cloudwatch_alarms.cpu_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.cpu_high.threshold
  alarm_description   = "This metric monitors Redis CPU utilization"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.redis.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.redis_name}-cpu-high"
  })
}

# High Memory Usage Alarm
resource "aws_cloudwatch_metric_alarm" "redis_memory_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.redis_name}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.memory_high.evaluation_periods
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = var.cloudwatch_alarms.memory_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.memory_high.threshold
  alarm_description   = "This metric monitors Redis memory usage percentage"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.redis.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.redis_name}-memory-high"
  })
}

# Evictions Alarm
resource "aws_cloudwatch_metric_alarm" "redis_evictions" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.redis_name}-evictions"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.evictions.evaluation_periods
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = var.cloudwatch_alarms.evictions.period
  statistic           = "Sum"
  threshold           = var.cloudwatch_alarms.evictions.threshold
  alarm_description   = "This metric monitors Redis evictions"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.redis.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.redis_name}-evictions"
  })
}

# High Swap Usage Alarm
resource "aws_cloudwatch_metric_alarm" "redis_swap_usage_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.redis_name}-swap-usage-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.swap_usage_high.evaluation_periods
  metric_name         = "SwapUsage"
  namespace           = "AWS/ElastiCache"
  period              = var.cloudwatch_alarms.swap_usage_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.swap_usage_high.threshold
  alarm_description   = "This metric monitors Redis swap usage"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.redis.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.redis_name}-swap-usage-high"
  })
}

# High Current Connections Alarm
resource "aws_cloudwatch_metric_alarm" "redis_connections_high" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.redis_name}-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.connections_high.evaluation_periods
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = var.cloudwatch_alarms.connections_high.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.connections_high.threshold
  alarm_description   = "This metric monitors Redis current connections"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.redis.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.redis_name}-connections-high"
  })
}

# Low Cache Hit Rate Alarm
resource "aws_cloudwatch_metric_alarm" "redis_cache_hit_rate_low" {
  count = var.enable_cloudwatch ? 1 : 0
  
  alarm_name          = "${var.project.env}-${var.project.name}-${var.redis_name}-cache-hit-rate-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cloudwatch_alarms.cache_hit_rate_low.evaluation_periods
  metric_name         = "CacheHitRate"
  namespace           = "AWS/ElastiCache"
  period              = var.cloudwatch_alarms.cache_hit_rate_low.period
  statistic           = "Average"
  threshold           = var.cloudwatch_alarms.cache_hit_rate_low.threshold
  alarm_description   = "This metric monitors Redis cache hit rate"
  treat_missing_data  = "notBreaching"

  dimensions = {
    CacheClusterId = aws_elasticache_cluster.redis.id
  }

  alarm_actions = var.cloudwatch_alarms.alarm_actions
  ok_actions    = var.cloudwatch_alarms.ok_actions

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${var.redis_name}-cache-hit-rate-low"
  })
}

#----------------------- CloudWatch Dashboard -----------------------
resource "aws_cloudwatch_dashboard" "redis_dashboard" {
  count = var.enable_cloudwatch ? 1 : 0
  
  dashboard_name = "${var.project.env}-${var.project.name}-${var.redis_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ElastiCache", "CPUUtilization", "CacheClusterId", aws_elasticache_cluster.redis.id]
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
            ["AWS/ElastiCache", "DatabaseMemoryUsagePercentage", "CacheClusterId", aws_elasticache_cluster.redis.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Memory Usage (%)"
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
            ["AWS/ElastiCache", "CacheHits", "CacheClusterId", aws_elasticache_cluster.redis.id],
            [".", "CacheMisses", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = var.project.region
          title  = "Cache Hits vs Misses"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ElastiCache", "CacheHitRate", "CacheClusterId", aws_elasticache_cluster.redis.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Cache Hit Rate (%)"
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
            ["AWS/ElastiCache", "Evictions", "CacheClusterId", aws_elasticache_cluster.redis.id]
          ]
          period = 300
          stat   = "Sum"
          region = var.project.region
          title  = "Evictions"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ElastiCache", "CurrConnections", "CacheClusterId", aws_elasticache_cluster.redis.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Current Connections"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ElastiCache", "NetworkBytesIn", "CacheClusterId", aws_elasticache_cluster.redis.id],
            [".", "NetworkBytesOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Network Throughput (Bytes)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ElastiCache", "SwapUsage", "CacheClusterId", aws_elasticache_cluster.redis.id]
          ]
          period = 300
          stat   = "Average"
          region = var.project.region
          title  = "Swap Usage (Bytes)"
        }
      }
    ]
  })
}

