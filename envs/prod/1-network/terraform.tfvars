########################## TERRAFORM.TFVARS ##########################
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

