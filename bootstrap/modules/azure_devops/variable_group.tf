resource "azuredevops_variable_group" "example" {
  project_id   = local.project_id
  name         = var.variable_group_name
  description  = var.variable_group_name
  allow_access = true

  variable {
    name  = "Example"
    value = "TBC"
  }
}