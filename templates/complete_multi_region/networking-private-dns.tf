module "private_dns_zones" {
  source = "./modules/private-dns"

  count = var.private_dns_zones_enabled ? 1 : 0

  locations                  = local.private_dns_zone_locations
  resource_group_name        = local.private_dns_zones_resource_group_name
  connected_virtual_networks = local.private_dns_zones_virtual_networks
  enable_telemetry           = var.enable_telemetry
  tags                       = var.private_dns_zones_tags

  depends_on = [
    module.resource_groups
  ]

  providers = {
    azurerm = azurerm.connectivity,
  }
}
