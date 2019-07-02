variable "acm_certificate_arn" {
  description = "The ARN for the certificate that should be used for SSL"
}

variable "bucket_name" {
  description = "S3 bucket name"
}

variable "domain" {
  description = "Vanity subdomain for cloudfront distribution"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

