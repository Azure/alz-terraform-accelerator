module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "4.2.0"

  disable_telemetry = true

  default_location = var.default_location
  root_parent_id   = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id

  deploy_corp_landing_zones    = true
  deploy_management_resources  = true
  deploy_online_landing_zones  = true
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_connectivity = var.subscription_id_connectivity
  subscription_id_identity     = var.subscription_id_identity
  subscription_id_management   = var.subscription_id_management

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}

module "hubnetworking" {
  source  = "Azure/hubnetworking/azurerm"
  version = "1.1.0"

  hub_virtual_networks = {
    primary-hub = {
      name                = "vnet-hub-${var.default_location}"
      address_space       = [var.hub_virtual_network_address_prefix]
      location            = var.default_location
      resource_group_name = "rg-connectivity-${var.default_location}"
      firewall = {
        subnet_address_prefix = var.firewall_subnet_address_prefix
        sku_tier              = "Standard"
        sku_name              = "AZFW_VNet"
      }
    }
  }

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.enterprise_scale
  ]
}

module "virtual_network_gateway" {
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.2.0"

  count = var.virtual_network_gateway_creation_enabled ? 1 : 0

  location                            = var.default_location
  name                                = "vgw-hub-${var.default_location}"
  sku                                 = "VpnGw1"
  subnet_address_prefix               = var.gateway_subnet_address_prefix
  type                                = "Vpn"
  enable_telemetry                    = false
  virtual_network_name                = module.hubnetworking.virtual_networks["primary-hub"].name
  virtual_network_resource_group_name = "rg-connectivity-${var.default_location}"

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.hubnetworking
  ]
}
