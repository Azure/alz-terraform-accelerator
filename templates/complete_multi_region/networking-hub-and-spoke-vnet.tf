module "hub_and_spoke_vnet" {
  source = "./modules/hub-and-spoke-vnet"

  count = !var.skip_deploy && local.connectivity_hub_and_spoke_vnet_enabled ? 1 : 0

  hub_and_spoke_networks_settings = local.hub_and_spoke_vnet_settings
  hub_virtual_networks            = local.hub_and_spoke_vnet_virtual_networks
  enable_telemetry                = var.enable_telemetry

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_es,
    module.management_avm,
    module.resource_groups
  ]
}
