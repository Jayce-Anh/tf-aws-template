############################### SECRET MANAGER VARIABLE ###############################

#================ Project =================#
variable "project" {
  type        = map(any)
  description = "Project configuration"
}

variable "tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

#================ Secret ==================#
variable "secret_kms_key" {
  type        = string
  description = "KMS key ARN to encrypt secrets"
}

variable "secret_rds" {
  type        = map(any)
  sensitive   = true
  description = "RDS credentials"
}
