############################### VARIABLES ###############################

#================ Project =================#
variable "project" {
  type        = map(any)
  description = "Project configuration"
}

variable "tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

#================ SQS =================#
variable "sqs_name" {
  type        = string
  default     = "sqs"
  description = "Suffix for the SQS queue name"
}

variable "sqs_kms_key" {
  type        = string
  description = "KMS key ARN for SQS message encryption"
}
