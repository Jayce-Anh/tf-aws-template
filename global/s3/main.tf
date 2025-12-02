############################ S3 BUCKET BACKEND ############################
module "backend_prod" {
  source        = "../../modules/s3/backend"
  project       = local.project
  tags          = local.tags
  account_index = var.backends.prod.account_index
  bucket_name   = var.backends.prod.bucket_name
  
  providers = {
    aws = aws.prod
  }
}

module "backend_dev" {
  source        = "../../modules/s3/backend"
  project       = local.project
  tags          = local.tags
  account_index = var.backends.dev.account_index
  bucket_name   = var.backends.dev.bucket_name
  
  providers = {
    aws = aws.dev
  }
}