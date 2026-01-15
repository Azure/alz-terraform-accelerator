output "connection" {
  value = data.azurerm_client_config.current
}

output "subscription" {
  value = data.azurerm_subscription.current
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

output "parent_management_group_display_name" {
  value = data.azurerm_management_group.example_parent.display_name
}

output "management_groups" {
  value = module.management_groups
}

output "resource_group_names" {
  value = {
    management   = azurerm_resource_group.management.name
    connectivity = azurerm_resource_group.connectivity.name
    identity     = azurerm_resource_group.identity.name
    security     = azurerm_resource_group.security.name
  }
}

output "boolean_test" {
  value = var.boolean_test
}
