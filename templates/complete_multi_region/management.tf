module "management_groups" {
  source = "./modules/management-es"

  count = var.skip_deploy ? 0 : (var.management_use_avm ? 0 : 1)

  enable_telemetry = var.enable_telemetry
  settings         = local.management_settings_es

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
