resource "azurerm_storage_account" "alz" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.state.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = true
}

resource "azurerm_storage_container" "alz" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.alz.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "alz_storage_container" {
  scope                = azurerm_storage_container.alz.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.alz.principal_id
}
