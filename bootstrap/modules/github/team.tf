data "github_organization" "alz" {
  name = var.organization_name
}

locals {
  approvers = [for user in data.github_organization.alz.users : user.login if contains(var.approvers, user.email)]
}

resource "github_team" "alz" {
  name        = var.team_name
  description = "Approvers for the Landing Zone Terraform Apply"
  privacy     = "closed"
}

resource "github_team_membership" "alz" {
  for_each = { for approver in local.approvers : approver => approver }
  team_id  = github_team.alz.id
  username = each.key
  role     = "member"
}

resource "github_team_repository" "alz" {
  team_id    = github_team.alz.id
  repository = github_repository.alz.name
  permission = "push"
}
