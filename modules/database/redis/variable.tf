variable "project" {
  type = object({
    name        = string
    env         = string
    region      = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

variable "redis_name" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "allowed_sg_ids_access_redis" {
  type = list(string)
}

variable "allowed_cidr_blocks_access_redis" {
  type = list(string)
}

variable "redis_parameters" {
  type        = map(string)
  description = "Custom parameters for Cache instance"
}

variable "redis_engine" {
  type = string
}

variable "redis_family" {
  type = string
}

variable "redis_node_type" {
  type = string
}

variable "redis_num_cache_nodes" {
  type = string
}

variable "redis_engine_version" {
  type = string
}

variable "redis_snapshot_retention_limit" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
