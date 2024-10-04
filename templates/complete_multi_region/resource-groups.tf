module "resource_group_private_dns_zones" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  count = local.private_dns_enabled ? 1 : 0

  name             = try(local.module_private_dns.resource_group_name, "rg-private-dns-${var.starter_locations[0]}")
  location         = try(local.module_private_dns.location, [for location in local.module_private_dns.locations : location if location.is_primary][0].location)
  enable_telemetry = try(local.module_private_dns.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "resource_group_connectivity" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  count = var.connectity_type != "none" ? 1 : 0

  name             = try(local.module_private_dns.resource_group_name, "rg-private-dns-${var.starter_locations[0]}")
  location         = try(local.module_private_dns.location, [for location in local.module_private_dns.locations : location if location.is_primary][0].location)
  enable_telemetry = try(local.module_private_dns.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }
}
