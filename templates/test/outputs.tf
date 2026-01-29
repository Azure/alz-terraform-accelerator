output "connection" {
  value = data.azurerm_client_config.current
}

output "subscription_id_connectivity" {
  value = var.subscription_ids["connectivity"]
}

output "subscription_id_identity" {
  value = var.subscription_ids["identity"]
}

output "subscription_id_management" {
  value = var.subscription_ids["management"]
}

output "subscription_id_security" {
  value = var.subscription_ids["security"]
}

output "management_groups" {
  value = module.management_groups
}

output "resource_group_ids" {
  value = {
    azure_rm = {
      management   = azurerm_resource_group.management.id
      connectivity = azurerm_resource_group.connectivity.id
      identity     = azurerm_resource_group.identity.id
      security     = azurerm_resource_group.security.id
    }
    azapi = {
      management   = azapi_resource.resource_group_management.id
      connectivity = azapi_resource.resource_group_connectivity.id
      identity     = azapi_resource.resource_group_identity.id
      security     = azapi_resource.resource_group_security.id
    }
  }
}

output "boolean_test" {
  value = var.boolean_test
}
