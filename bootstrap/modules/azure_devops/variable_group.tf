resource "azuredevops_variable_group" "example" {
  project_id   = local.project_id
  name         = var.variable_group_name
  description  = var.variable_group_name
  allow_access = true

  variable {
    name  = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
    value = var.backend_azure_resource_group_name
  }

  variable {
    name  = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
    value = var.backend_azure_storage_account_name
  }

  variable {
    name  = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
    value = var.backend_azure_storage_account_container_name
  }
}
