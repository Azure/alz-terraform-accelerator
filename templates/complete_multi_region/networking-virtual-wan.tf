module "virtual_wan" {
  source = "./modules/virtual-wan"

  count = !var.skip_deploy && local.connectivity_virtual_wan_enabled ? 1 : 0

  virtual_wan_settings = local.virtual_wan_settings
  virtual_hubs         = local.virtual_wan_virtual_hubs
  enable_telemetry     = var.enable_telemetry

  providers = {
    azurerm = azurerm.connectivity
  }

  depends_on = [
    module.management_es,
    module.management_avm,
    module.resource_groups
  ]
}
