variable "datadog_aws_account" {
  default     = "464622532012"
  description = "AWS account provided by DatDog to give access to"
}

variable "datadog_external_id" {
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html
  description = "AWS External ID provided by DataDog for account isolation"
}

variable "datadog_policy_name" {
  default     = "DatadogReadOnlyPolicy"
  description = "AWS policy name"
}

variable "datadog_role_name" {
  default     = "DataDogReadonlyRole"
  description = "AWS Role name"
}
