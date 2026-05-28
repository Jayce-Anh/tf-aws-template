######################### VARIABLE VALUES #########################
#------------VPC------------#
cidr_block = "10.0.0.0/16"
subnet_az = {
  "ap-southeast-1a" = {
    az_index             = 0
    public_subnet_count  = 1
    private_subnet_count = 1
  }
  "ap-southeast-1b" = {
    az_index             = 1
    public_subnet_count  = 1
    private_subnet_count = 1
  }
}

#------------EKS------------#
eks_name = "test"
eks_version = "1.31"
endpoint_private_access = true
endpoint_public_access = true
endpoint_public_access_cidrs = ["0.0.0.0/0"]

eks_sg_ingress = {
  ingress_rules = {
    rule1 = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS access to EKS API"
    }
  }
}

node_groups = {
  node1 = {
    min_size       = 1
    max_size       = 2
    desired_size   = 1
    instance_types = ["t3.large", "t3a.large"]
    capacity_type  = "SPOT"
    ingress_rules = {
      rule1 = {
        from_port   = 30000
        to_port     = 30020
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow access to nodes"
      }
    }
  }
  node2 = {
    min_size       = 1
    max_size       = 2
    desired_size   = 1
    instance_types = ["t3.large", "t3a.large"]
    capacity_type  = "SPOT"
    ingress_rules = {
      rule1 = {
        from_port   = 30000
        to_port     = 30020
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow access to nodes"
      }
    }
  }
}

addons = []