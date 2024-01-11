resource "azurerm_resource_group" "state" {
  name     = var.resource_group_state_name
  location = var.azure_location
}

resource "azurerm_resource_group" "identity" {
  name     = var.resource_group_identity_name
  location = var.azure_location
}

resource "azurerm_resource_group" "agents" {
  count    = local.has_agent_container_instances ? 1 : 0
  name     = var.resource_group_agents_name
  location = var.azure_location
}

resource "azurerm_resource_group" "network" {
  count    = local.use_private_networking ? 1 : 0
  name     = var.resource_group_network_name
  location = var.azure_location
}
