module "private_dns_zones_resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"

  count = local.private_dns_enabled ? 1 : 0

  name             = try(local.module_private_dns.resource_group_name, "rg-dns-${var.starter_locations[0]}")
  location         = try(local.module_private_dns.location, var.starter_locations[0])
  enable_telemetry = try(local.module_private_dns.enable_telemetry, local.enable_telemetry)

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "private_dns_zones" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.4.0"

  for_each = local.private_dns_location_map

  location                                = each.key
  resource_group_name                     = module.private_dns_zones_resource_group[0].name
  resource_group_creation_enabled         = false
  virtual_network_resource_ids_to_link_to = local.private_dns_virtual_networks
  private_link_private_dns_zones          = each.value.is_primary ? null : local.private_dns_secondary_zones
  enable_telemetry                        = try(local.module_private_dns.enable_telemetry, local.enable_telemetry)

  depends_on = [module.private_dns_zones_resource_group]

  providers = {
    azurerm = azurerm.connectivity
  }
}
