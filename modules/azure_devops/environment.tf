resource "azuredevops_environment" "alz" {
  name       = var.environment_name
  project_id = local.project_id
}