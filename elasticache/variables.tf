variable "engine" {
  description = "redis, memcache, etc."
  # default = "redis"
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

variable "version" {
  # default = "3.2.4"
}

variable "vpc_id" {}
