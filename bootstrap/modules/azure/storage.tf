resource "azurerm_storage_account" "alz" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.state.name
  location                        = var.azure_location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = local.use_private_networking && !var.allow_storage_access_from_my_ip ? false : true
}

resource "azurerm_storage_account_network_rules" "alz" {
  count              = local.use_private_networking ? 1 : 0
  storage_account_id = azurerm_storage_account.alz.id
  default_action     = "Deny"
  ip_rules           = var.allow_storage_access_from_my_ip ? [data.http.ip[0].response_body] : []
  bypass             = ["None"]
}

data "azapi_resource_id" "storage_account_blob_service" {
  type      = "Microsoft.Storage/storageAccounts/blobServices@2022-09-01"
  parent_id = azurerm_storage_account.alz.id
  name      = "default"
}

resource "azapi_resource" "storage_account_container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01"
  parent_id = data.azapi_resource_id.storage_account_blob_service.id
  name      = var.storage_container_name
  body = jsonencode({
    properties = {
      publicAccess = "None"
    }
  })
  depends_on = [azurerm_storage_account_network_rules.alz]
}

resource "azurerm_role_assignment" "alz_storage_container" {
  for_each             = var.user_assigned_managed_identities
  scope                = azapi_resource.storage_account_container.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.alz[each.key].principal_id
}
