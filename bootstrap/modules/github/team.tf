data "github_organization" "alz" {
  name = var.organization_name
}

locals{
    approvers = [ for user in data.github_organization.alz.users : user.login if contains(var.approvers, user.email) ]
}

resource "github_team" "alz" {
  name = "Landing Zone Approvers"
  description  = "Approvers for the Landing Zone Terraform Apply"
  privacy     = "secret"
}

resource "github_team_membership" "some_team_membership" {
  for_each = { for approver in local.approvers : approver => approver }
  team_id  = github_team.alz.id
  username = each.key
  role     = "member"
}
