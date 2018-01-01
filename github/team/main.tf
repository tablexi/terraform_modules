resource "github_team" "mod" {
  name = "${var.name}"
  description = "${var.description}"
  privacy = "${var.privacy}"
}

resource "github_team_membership" "maintainer" {
  count = "${length(var.maintainers)}"
  team_id = "${github_team.mod.id}"
  username = "${element(var.maintainers, count.index)}"
  role = "maintainer"
}

resource "github_team_membership" "members" {
  count = "${length(var.members)}"
  team_id = "${github_team.mod.id}"
  username = "${element(var.members, count.index)}"
  role = "maintainer"
}
