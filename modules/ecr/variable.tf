############################ ECR VARIABLE ############################

#================ Project =================#
variable "project" {
  type        = map(any)
  description = "Project metadata (env, name)"
}

variable "tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

variable "ecr_kms_key" {
  type        = string
  description = "KMS key ARN for ECR image encryption"
}
