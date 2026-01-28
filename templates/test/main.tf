data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_management_group" "example_parent" {
  name = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id
}

locals {
  starter_location = var.starter_locations[0]
}

module "management_groups" {
  source                                  = "Azure/avm-ptn-alz/azurerm"
  version                                 = "0.18.0"
  architecture_name                       = "alz_custom"
  parent_resource_id                      = data.azurerm_management_group.example_parent.name
  location                                = local.starter_location
  subscription_placement_destroy_behavior = "intermediate_root"
}

resource "azurerm_resource_group" "management" {
  provider = azurerm.management
  name     = "e2e-test-management-azurerm-${var.resource_name_suffix}"
  location = local.starter_location
}

resource "azurerm_resource_group" "connectivity" {
  provider = azurerm.connectivity
  name     = "e2e-test-connectivity-azurerm-${var.resource_name_suffix}"
  location = local.starter_location
}

resource "azurerm_resource_group" "identity" {
  provider = azurerm.identity
  name     = "e2e-test-identity-azurerm-${var.resource_name_suffix}"
  location = local.starter_location
}

resource "azurerm_resource_group" "security" {
  provider = azurerm.security
  name     = "e2e-test-security-azurerm-${var.resource_name_suffix}"
  location = local.starter_location
}

resource "azapi_resource" "resource_group_management" {
  parent_id = "/subscriptions/${var.subscription_ids["management"]}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-management-azapi-${var.resource_name_suffix}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "resource_group_connectivity" {
  parent_id = "/subscriptions/${var.subscription_ids["connectivity"]}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-connectivity-azapi-${var.resource_name_suffix}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "resource_group_identity" {
  parent_id = "/subscriptions/${var.subscription_ids["identity"]}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-identity-azapi-${var.resource_name_suffix}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "resource_group_security" {
  parent_id = "/subscriptions/${var.subscription_ids["security"]}"
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "e2e-test-security-azapi-${var.resource_name_suffix}"
  location  = local.starter_location
  body = {
    properties = {}
  }
  schema_validation_enabled = false
}
