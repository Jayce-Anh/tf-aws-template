############################### SECRET MANAGER VARIABLE ###############################

#================ Project =================#
variable "project" {
  type = object({
    name = string
    env  = string
  })
  description = "Project configuration"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources"
}

#================ KMS =================#
variable "secret_kms_key" {
  type        = string
  description = "KMS key ARN to encrypt secrets"
}

variable "rds_credentials" {
  type = object({
    username = string
    password = string
    host     = string
    port     = string
  })
  description = "RDS credentials"
}
