variable "name" {
  type        = "string"
  description = "(Required) - Name of the group"
}

variable "users" {
  type        = "list"
  description = "(Required) - Users that are members of this group"
}

variable "policy_arn" {
  type        = "string"
  description = "(Required) - The ARN of the policy applied, ideally managed by AWS"
}
