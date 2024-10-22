data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_management_group" "example_parent" {
  name = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id
}

locals {
  starter_location = var.starter_locations[0]
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
  name     = "e2e-test-management-azurerm-${random_string.example.result}"
  location = local.starter_location
}

resource "azurerm_resource_group" "connectivity" {
  provider = azurerm.connectivity
  name     = "e2e-test-connectivity-azurerm-${random_string.example.result}"
  location = local.starter_location
}

resource "azurerm_resource_group" "identity" {
  provider = azurerm.identity
  name     = "e2e-test-identity-azurerm-${random_string.example.result}"
  location = local.starter_location
}

resource "azapi_resource" "resource_group_management" {
  parent_id = "/subscriptions/${var.subscription_id_management}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-management-azapi-${random_string.example.result}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "resource_group_connectivity" {
  parent_id = "/subscriptions/${var.subscription_id_connectivity}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-connectivity-azapi-${random_string.example.result}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "resource_group_identity" {
  parent_id = "/subscriptions/${var.subscription_id_identity}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-identity-azapi-${random_string.example.result}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}

module "subscription" {
  source = "../modules/test_module"
  subscription_id = data.azurerm_subscription.current.id
}
