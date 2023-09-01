resource "azurerm_resource_group" "state" {
  name     = local.parsed_azure_resource_names.resource_group_state
  location = var.azure_location
}

resource "azurerm_resource_group" "identity" {
  name     = local.parsed_azure_resource_names.resource_group_identity
  location = var.azure_location
}

resource "azurerm_resource_group" "agents" {
  count = local.is_authentication_scheme_managed_identity ? 1 : 0
  name     = local.parsed_azure_resource_names.resource_group_agents
  location = var.azure_location
}