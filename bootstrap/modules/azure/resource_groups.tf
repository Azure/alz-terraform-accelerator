resource "azurerm_resource_group" "state" {
  name     = var.resource_group_state_name
  location = var.azure_location
}

resource "azurerm_resource_group" "identity" {
  name     = var.resource_group_identity_name
  location = var.azure_location
}

resource "azurerm_resource_group" "agents" {
  count = var.create_agents_resource_group ? 1 : 0
  name     = var.resource_group_agents_name
  location = var.azure_location
}