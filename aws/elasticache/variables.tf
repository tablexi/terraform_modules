variable "create_parameter_group" {
  default = true
  description = "Create a parameter group in this module"
}

variable "engine" {
  description = "redis, memcache, etc."
  # default = "redis"
}

variable "engine_version" {
  # default = "3.2.4"
}

variable "env" {
  default = "production"
}

variable "name" {}

variable "node_type" {
  default = "cache.t2.micro"
}

variable "num_nodes" {
  default = 1
}

variable "parameter_group_name" {
  description = "Name of a parameter group to use with the Elasticache instance."
  default = ""
}

variable "port" {
  default = ""
}

variable "subnets" {
  type = "list"
}

variable "vpc_id" {}
