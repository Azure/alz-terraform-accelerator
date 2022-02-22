data "azurerm_client_config" "core" {
  provider = azurerm
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_client_config" "identity" {
  provider = azurerm.identity
}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

data "azurerm_client_config" "app000001" {
  provider = azurerm.app000001
}

data "azurerm_client_config" "app000002" {
  provider = azurerm.app000002
}
