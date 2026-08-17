############################## VARIABLE VALUES ##############################

#=============== Project ================#
variable "project" {
  type        = map(any)
  description = "Project configuration"
}

variable "tags" {
  type        = map(any)
  description = "Common tags applied to all resources"
}

variable "helm_repo" {
  type        = string
  description = "Helm repository URL"
}
