terraform {
  backend "s3" {
    bucket = "926379876634-todo-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}