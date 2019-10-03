variable "name" {
  type = string
}

variable "ses" {
  default     = false
  description = "Provide this instance with access to send mail via SES"
}

variable "s3_bucket" {
  type        = string
  default     = ""
  description = "Provide this instance with access to the bucket"
}

