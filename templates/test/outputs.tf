output "connection" {
  value = data.azurerm_client_config.current
}

output "subscription" {
  value = data.azurerm_subscription.current
}

output "subscription_id_connectivity" {
  value = var.subscription_id_connectivity
}

output "subscription_id_identity" {
  value = var.subscription_id_identity
}

output "subscription_id_management" {
  value = var.subscription_id_management
}

output "parent_management_group_display_name" {
  value = data.azurerm_management_group.example_parent.display_name
}

output "child_management_group_name" {
  value = azurerm_management_group.example_child.name
}

output "child_management_group_display_name" {
  value = azurerm_management_group.example_child.display_name
}

output "resource_group_names" {
  value = {
    management   = azurerm_resource_group.management.name
    connectivity = azurerm_resource_group.connectivity.name
    identity     = azurerm_resource_group.identity.name
  }
}
