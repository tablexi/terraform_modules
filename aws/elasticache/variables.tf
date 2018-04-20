variable "at_rest_encryption_enabled" {
  default = false
}

variable "create_parameter_group" {
  default = true
  description = "Create a parameter group in this module"
}

variable "engine" {
  description = "redis, memcache, etc."
}

variable "engine_version" {}

variable "env" {
  default = "production"
}

variable "force_replication_group" {
  default = false
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

variable "security_groups_for_ingress" {
  description = "Security groups which should be allowed ingress on the ElastiCache instance."
  default = []
}

variable "subnets" {
  type = "list"
}

variable "transit_encryption_enabled" {
  default = false
}

variable "vpc_id" {}
