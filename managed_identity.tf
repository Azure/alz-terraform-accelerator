resource "azurerm_user_assigned_identity" "alz" {
  location            = var.azure_location
  name                = local.parsed_azure_resource_names.user_assigned_managed_identity
  resource_group_name = azurerm_resource_group.identity.name
}

resource "azurerm_federated_identity_credential" "alz" {
  count = local.is_github || local.is_azure_devops && local.is_authentication_scheme_workload_identity_federation ? 1 : 0
  name                = "Azure Landing Zone Federated Identity Credential"
  resource_group_name = azurerm_resource_group.identity.name
  audience            = [local.default_audience_name]
  issuer              = local.is_azure_devops ? local.azure_devops_issuer_url : local.github_issuer_url
  parent_id           = azurerm_user_assigned_identity.alz.id
  subject             = (local.is_azure_devops ?
    "sc://${var.version_control_system_organization}/${var.azure_devops_project_name}/service_connection_${var.azure_environment_name}" : 
    "repo:${var.version_control_system_organization}/${var.version_control_system_repository_name}:environment:${var.azure_environment_name}")
}