module "resource_groups" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  for_each = { for key, value in module.config.connectivity_resource_groups : key => value if value.enabled }

  name             = each.value.name
  location         = each.value.location
  enable_telemetry = var.enable_telemetry
  tags             = module.config.tags

  providers = {
    azurerm = azurerm.connectivity
  }
}
