resource "azurerm_storage_account" "alz" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.state.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
}

resource "azurerm_storage_account_network_rules" "alz" {
  count              = local.use_private_networking ? 1 : 0
  storage_account_id = azurerm_storage_account.alz.id
  default_action     = "Deny"
  ip_rules           = var.allow_storage_access_from_my_ip ? [data.http.ip[0].response_body] : []
  bypass             = ["None"]
}

resource "azurerm_storage_container" "alz" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.alz.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account_network_rules.alz]
}

resource "azapi_update_resource" "storage_public_access_disabled" {
  count       = local.use_private_networking && !var.allow_storage_access_from_my_ip ? 1 : 0
  type        = "Microsoft.Storage/storageAccounts@2023-01-01"
  resource_id = azurerm_storage_account.alz.id

  body = jsonencode({
    properties = {
      publicNetworkAccess = "Disabled"
    }
  })

  depends_on = [
    azurerm_storage_container.alz
  ]
}

resource "azurerm_role_assignment" "alz_storage_container" {
  for_each             = var.user_assigned_managed_identities
  scope                = azurerm_storage_container.alz.resource_manager_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.alz[each.key].principal_id
}
