variable "bucket_id" {}

variable "env" {
  default = "Prod"
}

variable "name" {}

variable "users" {
  type = "list"
}
