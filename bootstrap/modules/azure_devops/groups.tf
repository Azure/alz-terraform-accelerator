resource "azuredevops_group" "alz_approvers" {
  scope        = local.project_id
  display_name = "Landing Zone Approvers"
  description  = "Approvers for the Landing Zone Terraform Apply"
}

data "azuredevops_users" "alz" {
  for_each       = { for approver in var.approvers : approver => approver }
  principal_name = each.key
}

locals {
  approvers = toset(flatten([for approver in data.azuredevops_users.alz :
    [for user in approver.users : user.descriptor]
  ]))
}

resource "azuredevops_group_membership" "alz_approvers" {
  group   = azuredevops_group.alz_approvers.descriptor
  members = local.approvers
}