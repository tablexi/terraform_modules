variable "name" {
  type = string
}

variable "ses" {
  default     = false
  description = "Provide this instance with access to send mail via SES"
}

variable "sns" {
  default     = false
  description = "Provide this instance with access to interact with the Simple Notification Service"
}

variable "s3_bucket" {
  type        = string
  default     = ""
  description = "Provide this instance with access to the bucket"
}

