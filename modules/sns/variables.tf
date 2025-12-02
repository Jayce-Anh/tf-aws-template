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


variable "URL_GG_HOOK" {
  type = string
}