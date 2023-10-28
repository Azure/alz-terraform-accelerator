resource "azuredevops_environment" "alz" {
  for_each   = var.environments
  name       = each.value.environment_name
  project_id = local.project_id
}

resource "azuredevops_check_approval" "alz" {
  count                = length(var.approvers) == 0 ? 0 : 1
  project_id           = local.project_id
  target_resource_id   = azuredevops_environment.alz[local.apply_key].id
  target_resource_type = "environment"

  requester_can_approve = length(var.approvers) == 1
  approvers = [
    azuredevops_group.alz_approvers.origin_id
  ]

  timeout = 43200
}

resource "azuredevops_check_exclusive_lock" "alz" {
  for_each             = var.environments
  project_id           = local.project_id
  target_resource_id   = azuredevops_environment.alz[each.key].id
  target_resource_type = "environment"
  timeout              = 43200
}
