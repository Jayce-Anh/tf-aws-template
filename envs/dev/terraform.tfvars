########################## TERRAFORM.TFVARS ##########################
#---------VPC---------#
cidr_block = "10.0.0.0/16"
subnet_az = {
  "us-east-1a" = {
    az_index             = 0
    public_subnet_count  = 1
    private_subnet_count = 1
  }
  "us-east-1c" = {
    az_index             = 1
    public_subnet_count  = 1
    private_subnet_count = 1
  }
}

#---------ACM---------#
domain = "*.todo.jayce-lab.work"

#---------PARAMETER STORE---------#
source_services = ["be", "fe"]

#---------EC2---------#
instance_name = "app-server"
key_name = "lab-jayce"
path_user_data = "../../scripts/user_data/ubuntu-user_data.sh"
sg_ingress = {
  rule1 = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH access"
  }
  rule2 = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow traffic from ALB to nginx"
  }
}

sg_egress = {
  rule1 = {}
}

#---------ALB---------#
lb_name = "ex-alb"
enable_https_listener = true

target_groups = {
  be = {
    name              = "be"
    service_port      = 80
    health_check_path = "/health"
    priority          = 1
    host_header       = "dev-be.todo.jayce-lab.work"
    description       = "Allow traffic from ALB to nginx for backend"
  }
  fe = {
    name              = "fe"
    service_port      = 80
    health_check_path = "/health"
    priority          = 2
    host_header       = "dev-fe.todo.jayce-lab.work"
    description       = "Allow traffic from ALB to nginx for frontend"
  }
}

#---------AUTO SCALING GROUP---------#
# Enable ASG for high availability across multiple AZs
enable_asg                = true

# Capacity settings
desired_capacity          = 2  # Start with 2 instances (one per AZ)
min_size                  = 2  # Minimum 2 for high availability
max_size                  = 3  # Scale up to 3 during high load

# Health check configuration
health_check_type         = "ELB"  # Use ALB health checks
health_check_grace_period = 300    # 5 minutes for instance initialization

# Termination policies
termination_policies = ["OldestInstance", "Default"]

# Auto Scaling Policy - CPU-based
enable_cpu_scaling = true
cpu_target_value   = 90  # Scale when average CPU > 90%

# CloudWatch metrics
enabled_metrics = [
  "GroupMinSize",
  "GroupMaxSize",
  "GroupDesiredCapacity",
  "GroupInServiceInstances",
  "GroupTotalInstances"
]

