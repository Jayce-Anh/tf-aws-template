locals {
  # Project configuration
  project = {
    name       = "todo"
    env        = "dev"
    region     = "us-east-1"
    account_ids = ["701604998432", "926379876634"]
  }
  # Tags configuration
  tags = {
    Name = "${local.project.env}-${local.project.name}"
    env  = "${local.project.env}"
  }
}