##################################### DATA #####################################

# Fetch GitHub token from AWS Secrets Manager after the secret module exists.
data "aws_secretsmanager_secret_version" "github_token_secret" {
  secret_id  = module.secret_manager.secret_ids["github_token"]
  depends_on = [module.secret_manager]
}
