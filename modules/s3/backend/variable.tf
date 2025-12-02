##################### VARIABLES #####################
variable "project" {
  type = object({
    name = string
    region = string
    account_ids = list(string)
  })
}

variable "account_index" {
  type = number
  description = "Account index"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name suffix"
  default     = "terraform-state"
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "sse_algorithm" {
  type        = string
  description = "Server-side encryption algorithm"
  default     = "AES256"
}