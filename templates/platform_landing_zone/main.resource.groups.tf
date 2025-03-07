module "resource_groups" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.0"

  for_each = module.config.connectivity_resource_groups

  name             = each.value.name
  location         = each.value.location
  enable_telemetry = var.enable_telemetry
  tags             = module.config.tags

  providers = {
    azurerm = azurerm.connectivity
  }
}
