variable "key_name" {}

variable "name" {
  description = "Name of the cluster"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = "map"
}
