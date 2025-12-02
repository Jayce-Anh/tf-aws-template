########################## LOCAL VARIABLES ##########################
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
  # Github configuration
  github = {
    fe = {
      url          = "https://github.com/Jayce-Anh/todo_app-fe.git"
      name         = "todo_app-fe"
      branch       = "prod"
      organization = "Jayce-Anh"
      token        = local.github_token
    }
    be = {
      url          = "https://github.com/Jayce-Anh/todo_app-be.git"
      name         = "todo_app-be"
      branch       = "prod"
      organization = "Jayce-Anh"
      token        = local.github_token
    }
  }
}

# Pull outputs from application module
data "terraform_remote_state" "application" {
  backend = "s3"
  config = {
    bucket = "701604998432-todo-terraform-state"
    key    = "prod/application/terraform.tfstate"
    region = "us-east-1"
  }
}

# Pull outputs from dependence module
data "terraform_remote_state" "dependence" {
  backend = "s3"
  config = {
    bucket = "701604998432-todo-terraform-state"
    key    = "prod/dependence/terraform.tfstate"
    region = "us-east-1"
  }
}

# Fetch secret from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "github_token_secret" {
  secret_id = data.terraform_remote_state.dependence.outputs.secret_ids["github_token"]
}

locals {
  # Try to parse as JSON first, fall back to plain text
  github_token = try(
    jsondecode(data.aws_secretsmanager_secret_version.github_token_secret.secret_string).github_token,
    data.aws_secretsmanager_secret_version.github_token_secret.secret_string
  )
}