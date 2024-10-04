module "hub_and_spoke_vnet" {
  source = "./modules/hub-and-spoke-vnet"

  count = var.connectivity_type == "hub_and_spoke_vnet" ? 1 : 0

  hub_virtual_networks = local.hub_and_spoke_vnet_virtual_networks
  enable_telemetry     = var.enable_telemetry

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_groups,
    module.resource_groups
  ]
}
