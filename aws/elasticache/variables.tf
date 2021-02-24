variable "at_rest_encryption_enabled" {
  default = false
}

variable "automatic_failover_enabled" {
  default     = false
  description = "(Optional) Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false."
}

variable "create_parameter_group" {
  default     = true
  description = "Create a parameter group in this module"
}

variable "engine" {
  description = "redis, memcache, etc."
}

variable "engine_version" {
}

variable "env" {
  default = "production"
}

variable "force_replication_group" {
  default = false
}

variable "maintenance_window" {
  default     = ""
  description = "Set the weekly maintenance window for the cluster. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC)"
}

variable "name" {
}

variable "node_type" {
  default = "cache.t2.micro"
}

variable "num_nodes" {
  default = 1
}

variable "parameter_group_name" {
  description = "Name of a parameter group to use with the Elasticache instance."
  default     = ""
}

variable "port" {
  default = ""
}

variable "security_groups_for_ingress" {
  description = "Security groups which should be allowed ingress on the ElastiCache instance."
  default     = []
}

variable "sg_cidr_blocks" {
  description = "CIDR blocks which should be allowed ingress on the ElastiCache instance."
  default     = []
}

variable "subnets" {
  type = list(string)
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "transit_encryption_enabled" {
  default = false
}

variable "vpc_id" {
}

