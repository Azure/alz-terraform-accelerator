data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_management_group" "example_parent" {
  display_name = var.parent_management_group_display_name
}

resource "random_string" "example" {
  length  = 10
  special = false
  numeric = false
  upper   = false
}

resource "azurerm_management_group" "example_child" {
  name                       = "e2e-test-${random_string.example.result}"
  display_name               = "${var.child_management_group_display_name} ${random_string.example.result}"
  parent_management_group_id = data.azurerm_management_group.example_parent.id
}

resource "azurerm_resource_group" "management" {
  provider = azurerm.management
  name     = "e2e-test-management-${random_string.example.result}"
  location = var.resource_group_location
}

resource "azurerm_resource_group" "connectivity" {
  provider = azurerm.connectivity
  name     = "e2e-test-connectivity-${random_string.example.result}"
  location = var.resource_group_location
}

resource "azurerm_resource_group" "identity" {
  provider = azurerm.identity
  name     = "e2e-test-identity-${random_string.example.result}"
  location = var.resource_group_location
}
