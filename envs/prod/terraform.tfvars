######################### VARIABLE VALUES #########################

#---------VPC---------#
cidr_block = "10.0.0.0/16"
subnet_az = {
  "us-east-1a" = {
    az_index             = 0
    public_subnet_count  = 1
    private_subnet_count = 2
  }
  "us-east-1c" = {
    az_index             = 1
    public_subnet_count  = 1
    private_subnet_count = 2
  }
}

#-----------ACM------------#
domain_alb  = "*.todo.jayce-lab.work"
domain_s3cf = "*.todo.jayce-lab.work"

#-----------Secret Manager------------#
secrets = {
  be = {
    secret_name       = "be"
    use_initial_value = true
    secret_data       = {}
  }
  fe = {
    secret_name       = "fe"
    use_initial_value = true
    secret_data       = {}
  }
  github_token = {
    secret_name       = "github_token"
    use_initial_value = true
    secret_data       = {}
  }
}

#-----------ECR------------#
source_services = ["be"]

#-----------Bastion---------#
instance_type  = "t3.small"
path_user_data = "../../scripts/user_data/ubuntu-user_data.sh"
key_name       = "lab-jayce"
sg_ingress = {
  rule1 = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH access"
  }
  rule2 = {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "Connect to RDS MySQL"
    cidr_blocks = null
  }
}

sg_egress = {
  rule1 = {}
}

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
redis_name            = "redis"
redis_engine          = "redis"
redis_num_cache_nodes = 1
redis_node_type       = "cache.t4g.micro"
redis_family          = "redis6.x"

#-----------ECS------------#
ecs_task_definitions = {
  "be" = {
    container_name    = "be"
    desired_count     = 1
    container_port    = 5000
    host_port         = 5000
    health_check_path = "/health"
    load_balancer = {
      target_group_port = 5000
      container_port    = 5000
    }
  }
}
ecs_enable_cloudwatch = true

#---------FE Pipeline---------#
fe_pipeline_name      = "fe"
fe_build_name         = "fe"
fe_buildspec_file     = "../../scripts/pipeline/fe-buildspec.yml"
fe_env_vars_codebuild = {}

#---------BE Pipeline---------#
be_pipeline_name      = "be"
be_build_name         = "be"
be_buildspec_file     = "../../scripts/pipeline/be-buildspec.yml"
be_env_vars_codebuild = {}
