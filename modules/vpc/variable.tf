########################## VPC VARIABLE ##########################

#=============== Project ================#
variable "project" {
  type        = map(any)
  description = "Project configuration"
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to the VPC"
}


