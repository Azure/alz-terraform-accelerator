data "azurerm_client_config" "core" {}

data "azurerm_management_group" "root" {
  name = local.root_parent_management_group_id
}
