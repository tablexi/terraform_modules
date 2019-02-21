variable "ami" {
  description = "AMI used to build each node"
  default     = "ami-0c5b63ec54dd3fc38"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "subnets" {
  description = "The subnet ids to create nodes in"
  type        = "list"
}

variable "vpc_id" {
  description = "The id of the VPC to create nodes in"
}

variable "master_security_group_id" {
  description = "Security group id from the master control plane"
  type        = "map"
}

variable "capacity_min" {
  description = "Minimum number of nodes to create"
  default     = 3
}

variable "capacity_desired" {
  description = "Desired number of nodes to create"
  default     = 3
}

variable "capacity_max" {
  description = "Maximum number of nodes to create"
  default     = 6
}

variable "key_name" {}

variable "name" {
  description = "Name of the cluster"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = "map"
}
