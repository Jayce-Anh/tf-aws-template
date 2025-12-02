####################### VARIABLES VALUES #####################

#-----------ACM------------#
domain_alb  = "*.todo.jayce-lab.work"
domain_s3cf = "*.todo.jayce-lab.work"

#-----------Secret Manager------------#
secrets = {
  be = {
    secret_name = "be"
    use_initial_value = true
    secret_data = {}
  }
  fe = {
    secret_name = "fe"
    use_initial_value = true
    secret_data = {}
  }
  github_token = {
    secret_name = "github_token"
    use_initial_value = true
    secret_data = {}
  }
}

#-----------Parameter Store------------#
# parameter_store_services = ["be"]

#-----------ECR------------#
source_services = ["be"]

#-----------Bastion---------#
instance_type  = "t3.small"
path_user_data = "../../../scripts/user_data/ubuntu-user_data.sh"
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
    cidr_block  = null
  }
}

sg_egress = {
  rule1 = {}
}