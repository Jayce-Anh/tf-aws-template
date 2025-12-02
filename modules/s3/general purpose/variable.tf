##################### VARIABLES #####################
variable "project" {
  type = object({
    name = string
    env = string
    region = string
    account_ids = list(number)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "bucket_name" {
  type = string
  description = "Name of the S3 bucket"
}

variable "versioning" {
  type = object({
    status = string
    mfa_delete = string
  })
  description = "Versioning configuration"
  default = {
    status = "Enabled"
    mfa_delete = null
  }
}

variable "sse_algorithm" {
  type = string
  description = "Server-side encryption algorithm"
  default = "AES256"
}

variable "block_public_acls" {
  type = bool
  description = "Block public ACLs"
  default = true
}

variable "block_public_policy" {
  type = bool
  description = "Block public policy"
  default = true
}

variable "ignore_public_acls" {
  type = bool
  description = "Ignore public ACLs"
  default = true
}

variable "restrict_public_buckets" {
  type = bool
  description = "Restrict public buckets"
  default = true
}