variable "description" {
  default = ""
  description = "Team description"
}

variable "maintainers" {
  description = "List of team maintainers"
  type = "list"
}

variable "members" {
  default = []
  description = "List of team members"
  type = "list"
}

variable "name" {
  description = "Team name"
}

variable "privacy" {
  default = "secret"
  description = "The level of privacy this team should have."
}
