variable "project" {
  type = object({
    env = string
    name = string
    region = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
    env = string
  })
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

