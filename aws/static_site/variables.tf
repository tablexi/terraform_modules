variable "acm_certificate_arn" {
  description = "The ARN for the certificate that should be used for SSL"
}

variable "bucket_name" {
  description = "S3 bucket name"
}

variable "domains" {
  description = "Vanity subdomains for cloudfront distribution"
  type        = list(string)
}

variable "index_document" {
  description = "The document that will be served up by the s3 bucket's static site hosting"
  default     = "index.html"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}

variable "enable_cors_get" {
  description = "Enables Cross Origin Resource Sharing (CORS) get requests from any origin."
  type        = bool
  default     = false
}

variable "cors_rule" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = any
  default = [{
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }]
}

variable "versioning" {
  description = "Enables versioning in the s3 bucket"
  type        = bool
  default     = false
}
