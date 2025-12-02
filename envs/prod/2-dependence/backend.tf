terraform {
  backend "s3" {
    bucket = "701604998432-todo-terraform-state"
    key    = "prod/dependence/terraform.tfstate"
    region = "us-east-1"
  }
}