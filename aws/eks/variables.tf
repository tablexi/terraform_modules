variable "name" {
  description = "Name of the cluster"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "ami" {
  description = "AMI used to build each node"
  default     = "ami-0d9f458329e942f90"
}

variable "instance_type" {
  default = "t3.medium"
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

variable "key_name" {
}

