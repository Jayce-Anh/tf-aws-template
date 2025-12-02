############################### SECRET MANAGER - VARIABLE ###############################
variable "project" {
  type = object({
    name = string
    env  = string
    region = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "secrets" {
  type = map(object({
    secret_name           = string
    use_initial_value     = optional(bool, true)
    secret_data           = optional(map(string), {})
    recovery_window_in_days = optional(number, 30)
  }))
  description = "Map of secrets to create"
  default     = {}
}
