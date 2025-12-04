module "virtual_wan" {
  source  = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version = "0.13.2"

  count = local.connectivity_virtual_wan_enabled ? 1 : 0

  virtual_wan_settings = local.virtual_wan_settings
  virtual_hubs         = local.virtual_hubs
  enable_telemetry     = var.enable_telemetry
  tags                 = coalesce(module.config.outputs.connectivity_tags, module.config.outputs.tags)

  providers = {
    azurerm = azurerm.connectivity
  }
}
