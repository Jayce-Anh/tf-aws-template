############### LOCAL VARIABLES ################
locals {
  # Project configuration
  project = {
    name        = "todo"
    env         = "prod"
    region      = "us-east-1"
    account_ids = ["701604998432"]
  }
  # Tags configuration
  tags = {
    Name = "${local.project.env}-${local.project.name}"
    env  = "${local.project.env}"
  }
}