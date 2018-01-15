variable "allow_merge_commit" {
  default = true
  description = "Enable merge commits"
}

variable "allow_rebase_merge" {
  default = true
  description = "Enable rebase merges"
}

variable "allow_squash_merge" {
  default = true
  description = "Enable squash merges"
}

variable "auto_init" {
  default = false
  description = "Make an initial commit on repository creation"
}

variable "collaborators" {
  default = []
  description = "List of maps of collaborators to give access to the repository"
  type = "list"
}

variable "default_branch" {
  default = ""
  description = "The name of the default branch of the repository"
}

variable "description" {
  default = ""
  description = "Description of repository"
}

variable "gitignore_template" {
  default = ""
  desciption = "Name of the gitignore template to use during repository creation."
}

variable "has_issues" {
  default = true
  description = "Enable github issues feature" }

variable "has_wiki" {
  default = true
  description = "Enable github wiki feature"
}

variable "homepage_url" {
  default = ""
  description = "Repository homepage"
}

variable "license_template" {
  default = ""
  description = "Name of license tempalte to use during repository creation"
}

variable "private" {
  default = true
  description = "Is the repository private or public"
}

variable "name" {
  description = "Name of repository"
}

variable "teams" {
  default = []
  description = "List of maps of teams to give access to repostiory"
  type = "list"
}

