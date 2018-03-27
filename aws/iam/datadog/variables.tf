variable "datadog_external_id" {
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html
  description = "AWS External ID provided by DataDog for account isolation"
}

variable "datadog_policy_name" {
  default     = "DataDogReadOnlyPolicy"
  description = "AWS policy name"
}

variable "datadog_role_name" {
  default     = "DataDogReadOnlyRole"
  description = "AWS Role name"
}
