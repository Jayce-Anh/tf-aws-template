module "secret_manager" {
  source          = "./modules/secret_manager"
  project         = local.project
  tags            = local.tags
  secrets         = {
    api_gateway = {
      secret_name       = "api-gateway"
      use_initial_value = true
    }

    webapp = {
      secret_name       = "webapp"
      use_initial_value = true
    }
  }
}