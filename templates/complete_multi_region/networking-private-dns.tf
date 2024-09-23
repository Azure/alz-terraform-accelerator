module "private_dns_zones" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.4.0"
 
  for_each = local.private_dns_location_map

  location = each.key
  resource_group_name = try(local.module_private_dns.resource_group_name, null)
  resource_group_creation_enabled  = try(local.module_private_dns.resource_group_creation_enabled, true)
  virtual_network_resource_ids_to_link_to = local.private_dns_virtual_networks
  private_link_private_dns_zones = each.value.is_primary ? null : local.private_dns_secondary_zones

  providers = {
    azurerm = azurerm.connectivity
  }
}
