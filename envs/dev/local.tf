locals {
  # Project configuration
  project = {
    name       = "eks"
    env        = "test"
    region     = "ap-southeast-1"
    account_ids = ["701604998432"]
  }
  # Tags configuration
  tags = {
    Name = "${local.project.env}-${local.project.name}"
    env  = "${local.project.env}"
  }
}