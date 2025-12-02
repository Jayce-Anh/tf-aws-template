######################## VARIABLES ########################
variable "backends" {
  type = map(object({ 
    account_index = number
    bucket_name = string
  }))
  description = "Map of backends to create"
}