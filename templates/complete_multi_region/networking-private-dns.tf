module "private_dns_zones" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.4.0"
 
  count = local.private_dns_enabled ? 1 : 0

  location = try(local.module_private_dns.location, var.starter_locations[0])
  resource_group_name = try(local.module_private_dns.resource_group_name, null)
  resource_group_creation_enabled  = try(local.module_private_dns.resource_group_creation_enabled, true)
  virtual_network_resource_ids_to_link_to = {}

  providers = {
    azurerm = azurerm.connectivity
  }
}