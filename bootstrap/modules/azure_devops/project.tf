resource "azuredevops_project" "alz" {
  count = var.create_project ? 1 : 0
  name  = var.project_name
}

data "azuredevops_project" "alz" {
  count = var.create_project ? 0 : 1
  name  = var.project_name
}

locals {
  project_id = var.create_project ? azuredevops_project.alz[0].id : data.azuredevops_project.alz[0].id
}
