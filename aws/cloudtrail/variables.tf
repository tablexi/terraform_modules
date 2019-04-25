variable "name" {
  description = "Name of trail and prefix for s3 bucket name"
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = "map"
}
