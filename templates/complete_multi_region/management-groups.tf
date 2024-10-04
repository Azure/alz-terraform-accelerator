module "management_groups" {
  source  = "./modules/management-groups-and-resources"

  enable_telemetry                                         = var.enable_telemetry
  location                                                = var.location
  settings                                                = local.management_groups.settings

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
