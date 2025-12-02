############################ VARIABLES ############################

variable "project" {
  type = object({
    name       = string
    env        = string
    region     = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "env_vars_codebuild" {}
variable "codebuild_role_arn" {}
variable "buildspec_file" {
  type = string
}

variable "build_name" {
  type = string
}

