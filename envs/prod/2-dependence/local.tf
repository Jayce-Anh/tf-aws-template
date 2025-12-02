############### LOCAL VARIABLES ################
locals {
  # Project configuration
  project = {
    name       = "todo"
    env        = "prod"
    region     = "us-east-1"
    account_ids = ["701604998432"]
  }
  # Tags configuration
  tags = {
    Name = "${local.project.env}-${local.project.name}"
    env  = "${local.project.env}"
  }
}

######################### DATA SOURCE #########################
# Pull output from network module
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "701604998432-todo-terraform-state"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}



