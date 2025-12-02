provider "aws" {
  region  = local.project.region
  profile = "jayce-lab-free"
}

provider "aws" {
  alias               = "prod"
  region              = local.project.region
  profile             = "jayce-lab-free"
  allowed_account_ids = [local.project.account_ids[0]]
}

provider "aws" {
  alias               = "dev"
  region              = local.project.region
  profile             = "jaeger-lab-6th"
  allowed_account_ids = [local.project.account_ids[1]]
}