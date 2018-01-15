resource "github_repository" "mod" {
  name = "${var.name}"
  description = "${var.description}"

  homepage_url = "${var.homepage_url}"
  private = "${var.private}"
  has_issues = "${var.has_issues}"
  has_wiki = "${var.has_wiki}"
  allow_merge_commit = "${var.allow_merge_commit}"
  allow_squash_merge = "${var.allow_squash_merge}"
  allow_rebase_merge = "${var.allow_rebase_merge}"
  auto_init = "${var.auto_init}"
  gitignore_template = "${var.gitignore_template}"
  license_template = "${var.license_template}"
  default_branch = "${var.default_branch}"
}

resource "github_repository_collaborator" "mod" {
  count = "${length(var.collaborators)}"
  repository = "${github_repository.mod.name}"
  username = "${lookup(element(var.collaborators, count.index), "username")}"
  permission = "${lookup(element(var.collaborators, count.index), "permission")}"
}

resource "github_team_repository" "mod" {
  count - "${length(var.teams)}"
  repository = "${github_repository.mod.name}"
  team_id = "${lookup(element(var.teams, count.index), "team_id")}"
  permission = "${lookup(element(var.teams, count.index), "permission")}"
}
