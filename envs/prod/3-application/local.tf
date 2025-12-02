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

# Pull output from dependence module
data "terraform_remote_state" "dependence" {
  backend = "s3"
  config = {
    bucket = "701604998432-todo-terraform-state"
    key    = "prod/dependence/terraform.tfstate"
    region = "us-east-1"
  }
}

# # Fetch secret from AWS Secrets Manager
# data "aws_secretsmanager_secret_version" "be_secrets" {
#   secret_id = data.terraform_remote_state.dependence.outputs.secret_ids["be"]
# }
# data "aws_secretsmanager_secret_version" "fe_secrets" {
#   secret_id = data.terraform_remote_state.dependence.outputs.secret_ids["fe"]
# }

# # Parse the JSON secret (with error handling for empty/invalid JSON)
# locals {
#   be_secrets = try(
#     jsondecode(data.aws_secretsmanager_secret_version.be_secrets.secret_string),
#     {
#       DB_USERNAME = "temporary_username"
#       DB_PASSWORD = "temporary_password"
#     }
#   )
# }