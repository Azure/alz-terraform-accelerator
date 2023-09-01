data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

module "azure_devops" {
  source = "./modules/azure_devops"
  providers = {
    azuredevops = azuredevops
  }
  count = local.is_azure_devops ? 1 : 0
  access_token = var.version_control_system_access_token
  organization_url = local.azure_devops_url
  authentication_scheme = var.azure_devops_authentication_scheme
  create_project = var.azure_devops_create_project
  project_name = var.azure_devops_project_name
  environment_name = local.resource_names.version_control_system_environment
  repository_name = local.resource_names.version_control_system_repository
  service_connection_name = local.resource_names.version_control_system_service_connection
  variable_group_name = local.resource_names.version_control_system_variable_group
  managed_identity_client_id = azurerm_user_assigned_identity.alz.client_id
  azure_tenant_id = data.azurerm_client_config.current.tenant_id
  azure_subscription_id = data.azurerm_client_config.current.subscription_id
  azure_subscription_name = data.azurerm_subscription.current.display_name
}

module "github" {
  source = "./modules/github"
  count = local.is_github ? 1 : 0
}