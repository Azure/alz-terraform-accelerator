module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "0.1.0"

  count = local.connectivity_hub_and_spoke_vnet_enabled ? 1 : 0

  hub_and_spoke_networks_settings = local.hub_and_spoke_vnet_settings
  hub_virtual_networks            = local.hub_and_spoke_vnet_virtual_networks
  enable_telemetry                = var.enable_telemetry
  tags                            = module.config.tags

  providers = {
    azurerm = azurerm.connectivity
  }
}
