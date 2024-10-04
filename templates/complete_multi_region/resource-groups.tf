module "resource_groups" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  for_each = local.resource_groups

  name             = each.value.name
  location         = each.value.location
  enable_telemetry = var.enable_telemetry

  providers = {
    azurerm = azurerm.connectivity
  }
}
