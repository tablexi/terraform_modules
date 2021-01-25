variable "name" {
  description = "Name of trail and prefix for s3 bucket name"
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "cloud_watch_logs_group_arn" {
  default     = ""
  description = "(Optional) The ARN of a CloudWatch Log Group for the trail"
}

variable "cloud_watch_logs_role_arn" {
  default     = ""
  description = "(Optional) The ARN of a Role with CloudWatch permissions to attach"
}
