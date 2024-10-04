module "private_dns_zones" {
  source  = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version = "0.4.0"

  for_each = var.locations

  location                                = each.value.location
  resource_group_name                     = var.resource_group_name
  resource_group_creation_enabled         = false
  virtual_network_resource_ids_to_link_to = var.connected_virtual_networks
  private_link_private_dns_zones          = each.value.is_primary ? null : local.private_dns_secondary_zones
  enable_telemetry                        = var.enable_telemetry
  tags                                    = var.tags
}
