resource "azurerm_virtual_network" "alz" {
  count               = local.use_private_networking ? 1 : 0
  name                = var.virtual_network_name
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.network[0].name
  address_space       = [var.virtual_network_address_space]
}

resource "azurerm_subnet" "container_instances" {
  count                                     = local.use_private_networking ? 1 : 0
  name                                      = var.virtual_network_subnet_name_container_instances
  resource_group_name                       = azurerm_resource_group.network[0].name
  virtual_network_name                      = azurerm_virtual_network.alz[0].name
  address_prefixes                          = [var.virtual_network_subnet_address_prefix_container_instances]
  private_endpoint_network_policies_enabled = true
  delegation {
    name = "aci-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "storage" {
  count                                     = local.use_private_networking ? 1 : 0
  name                                      = var.virtual_network_subnet_name_storage
  resource_group_name                       = azurerm_resource_group.network[0].name
  virtual_network_name                      = azurerm_virtual_network.alz[0].name
  address_prefixes                          = [var.virtual_network_subnet_address_prefix_storage]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_private_dns_zone" "alz" {
  count               = local.use_private_networking ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.network[0].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "alz" {
  count                 = local.use_private_networking ? 1 : 0
  name                  = var.private_endpoint_name
  resource_group_name   = azurerm_resource_group.network[0].name
  private_dns_zone_name = azurerm_private_dns_zone.alz[0].name
  virtual_network_id    = azurerm_virtual_network.alz[0].id
}

resource "azurerm_private_endpoint" "alz" {
  count               = local.use_private_networking ? 1 : 0
  name                = var.private_endpoint_name
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.network[0].name
  subnet_id           = azurerm_subnet.storage[0].id

  private_service_connection {
    name                           = var.private_endpoint_name
    private_connection_resource_id = azurerm_storage_account.alz.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = var.private_endpoint_name
    private_dns_zone_ids = [azurerm_private_dns_zone.alz[0].id]
  }
}
