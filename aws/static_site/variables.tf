variable "acm_certificate_arn" {
  description = "The ARN for the certificate that should be used for SSL"
}

variable "bucket_name" {
  description = "S3 bucket name"
}

variable "domain" {
  description = "Vanity subdomain for cloudfront distribution"
}

variable "index_document" {
  description = "The document that will be served up by the s3 bucket's static site hosting"
  default     = "index.html"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = "map"
}
