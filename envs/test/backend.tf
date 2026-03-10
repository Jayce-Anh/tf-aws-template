terraform {
  backend "s3" {
    bucket = "701604998432-test-terraform-state"
    key    = "test/terraform.tfstate"
    region = "ap-southeast-1"
  }
} 