variable "bucket_id" {
}

variable "env" {
  default = "Prod"
}

variable "name" {
}

variable "users" {
  type    = list(string)
  default = []
}

variable "roles" {
  type    = list(string)
  default = []
}

variable "groups" {
  type    = list(string)
  default = []
}
