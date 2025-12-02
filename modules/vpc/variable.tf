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
  })
}

variable "cidr_block" { type = string }

variable "subnet_az" {
  type = map(object({
    az_index           = number
    public_subnet_count  = number
    private_subnet_count = number
  }))
  description = "Map of AZ configurations with subnet counts"
}

