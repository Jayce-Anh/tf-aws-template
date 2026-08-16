################################# SECRET MANAGER #################################

#================= Gitlab Runner Token =================#
resource "aws_secretsmanager_secret" "gitlab-runner" {
  name                    = "${var.project.env}-${var.project.name}-gitlab-runner-token"
  recovery_window_in_days = 0
  kms_key_id              = var.secret_kms_key
  description             = "GitLab token registered of GitLab runner"

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-gitlab-runner-token"
  })
}

#================= MySQL Credentials =================#
resource "aws_secretsmanager_secret" "rds" {
  name                    = "${var.project.env}-${var.project.name}-rds-credentials"
  recovery_window_in_days = 0
  kms_key_id              = var.secret_kms_key
  description             = "RDS credentials"

  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-rds-credentials"
  })
}

#================ Secret Version =================#
resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode(var.rds_credentials)
}