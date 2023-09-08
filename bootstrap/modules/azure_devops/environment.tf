resource "azuredevops_environment" "alz_plan" {
  name       = var.environment_name_plan
  project_id = local.project_id
}

resource "azuredevops_environment" "alz_apply" {
  name       = var.environment_name_apply
  project_id = local.project_id
}