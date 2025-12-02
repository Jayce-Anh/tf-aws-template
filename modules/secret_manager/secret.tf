################################# SECRET MANAGER #################################

#Create secret
resource "aws_secretsmanager_secret" "secret" {
  for_each = var.secrets
  
  name                    = "${var.project.env}-${var.project.name}-${each.value.secret_name}"
  recovery_window_in_days = each.value.recovery_window_in_days
  
  tags = merge(var.tags, {
    Name = "${var.project.env}-${var.project.name}-${each.value.secret_name}"
  })
}

#Create secret version with initial value (changes ignored)
resource "aws_secretsmanager_secret_version" "secret_with_ignore" {
  for_each = {
    for k, v in var.secrets : k => v
    if v.use_initial_value
  }
  
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = "init"
  
  lifecycle {
    ignore_changes = [secret_string]
  }
}

#Create secret version with managed value (changes not ignored)
resource "aws_secretsmanager_secret_version" "secret_managed" {
  for_each = {
    for k, v in var.secrets : k => v
    if !v.use_initial_value
  }
  
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = jsonencode(each.value.secret_data)
}