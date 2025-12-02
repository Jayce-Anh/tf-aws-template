####################### VARIABLES VALUES #####################

#-----------External LB------------#
lb_name                = "ex-alb"
source_ingress_sg_cidr = ["0.0.0.0/0"]
target_groups = {
  be = {
    name              = "be"
    service_port      = 5000
    health_check_path = "/health"
    priority          = 1
    host_header       = "prod-be.todo.jayce-lab.work"
    target_type       = "ip"
    ec2_id            = ""
  }
}
alb_enable_cloudwatch = true

#-----------CloudFront------------#
service_name             = "fe"
cloudfront_domain        = "prod-fe.todo.jayce-lab.work"
cloudfront_force_destroy = true
custom_error_response = {
  "403" = {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
  "404" = {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }
}

#-----------RDS------------#
rds_name           = "mysql-db"
rds_class          = "db.t4g.micro"
rds_engine         = "mysql"
rds_engine_version = "8.0"
rds_port           = 3306
rds_family         = "mysql8.0"
aws_db_parameters = {
  "max_connections"          = 500
  "require_secure_transport" = 0
}
rds_enable_cloudwatch = true

#-----------Redis------------#
redis_name      = "redis"
redis_engine    = "redis"
redis_num_cache_nodes = 1
redis_node_type = "cache.t4g.micro"
redis_family    = "redis6.x"

#-----------ECS------------#
ecs_task_definitions = {
  "be" = {
    container_name       = "be"
    desired_count        = 1
    container_port       = 5000
    host_port            = 5000
    health_check_path    = "/health"
    load_balancer = {
      target_group_port = 5000
      container_port    = 5000
    }
  }
}
ecs_enable_cloudwatch = true
