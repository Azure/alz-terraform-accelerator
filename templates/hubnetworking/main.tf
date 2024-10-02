locals {
  starter_location = var.starter_locations[0]
}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 6.0.0"

  disable_telemetry = true

  default_location = local.starter_location
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
  version = "~> 1.1.0"

  hub_virtual_networks = {
    primary-hub = {
      name                = "vnet-hub-${local.starter_location}"
      address_space       = [var.hub_virtual_network_address_prefix]
      location            = local.starter_location
      resource_group_name = "rg-connectivity-${local.starter_location}"
      firewall = {
        subnet_address_prefix = var.firewall_subnet_address_prefix
        sku_tier              = "Standard"
        sku_name              = "AZFW_VNet"
        zones                 = ["1", "2", "3"]
        default_ip_configuration = {
          public_ip_config = {
            zones = ["1", "2", "3"]
            name  = "pip-hub-${local.starter_location}"
          }
        }
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
  version = "~> 0.3.0"

  count = var.virtual_network_gateway_creation_enabled ? 1 : 0

  location              = local.starter_location
  name                  = "vgw-hub-${local.starter_location}"
  subnet_address_prefix = var.gateway_subnet_address_prefix
  enable_telemetry      = false
  virtual_network_id    = module.hubnetworking.virtual_networks["primary-hub"].id

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.hubnetworking
  ]
}
