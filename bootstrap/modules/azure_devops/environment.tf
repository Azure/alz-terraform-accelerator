resource "azuredevops_environment" "alz_plan" {
  name       = var.environment_name_plan
  project_id = local.project_id
}

resource "azuredevops_environment" "alz_apply" {
  name       = var.environment_name_apply
  project_id = local.project_id
}

resource "azuredevops_check_approval" "alz" {
  count                = var.approvers == [] ? 0 : 1
  project_id           = local.project_id
  target_resource_id   = azuredevops_environment.alz_apply.id
  target_resource_type = "environment"

  requester_can_approve = length(var.approvers) == 1
  approvers = [
    azuredevops_group.alz_approvers.origin_id
  ]

  timeout = 43200
}

resource "azuredevops_check_exclusive_lock" "alz_plan" {
  project_id           = local.project_id
  target_resource_id   = azuredevops_environment.alz_plan.id
  target_resource_type = "environment"
  timeout              = 43200
}

resource "azuredevops_check_exclusive_lock" "alz_apply" {
  project_id           = local.project_id
  target_resource_id   = azuredevops_environment.alz_apply.id
  target_resource_type = "environment"
  timeout              = 43200
}
