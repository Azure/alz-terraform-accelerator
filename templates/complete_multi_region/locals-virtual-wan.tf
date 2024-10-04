locals {
  virtual_wan_virtual_hubs = { for key, value in var.virtual_wan_virtual_hubs : key => {
    name                        = templatestring(value.name, { location = value.location })
    location                    = value.location
    resource_group_name         = try(templatestring(value.resource_group_name, { location = value.location }), local.virtual_wan_resource_group_name)
    virtual_network_connections = value.virtual_network_connections
    firewall = try({
      name     = templatestring(value.firewall.name, { location = value.location })
      sku_name = try(value.firewall.sku_name, "AZFW_Hub")
      sku_tier = try(value.firewall.sku_tier, "Standard")
      zones    = try(value.firewall.zones, local.regions[value.location].zones)
      firewall_policy = {
        name     = templatestring(value.firewall.firewall_policy.name, { location = value.location })
        settings = value.firewall.firewall_policy.settings
      }
      settings = value.settings
    }, null)
    address_prefix         = value.address_prefix
    tags                   = try(value.tags, null)
    hub_routing_preference = try(value.hub_routing_preference, null)
    private_dns_zone_networking = try({
      virtual_network = {
        name          = templatestring(value.private_dns_zone_networking.virtual_network.name, { location = value.location })
        address_space = value.private_dns_zone_networking.virtual_network.address_space
        private_dns_resolver_subnet = {
          name           = templatestring(value.private_dns_zone_networking.virtual_network.private_dns_resolver_subnet.name, { location = value.location })
          address_prefix = value.private_dns_zone_networking.virtual_network.private_dns_resolver_subnet.address_prefix
        }
      }
      private_dns_resolver = {
        name = templatestring(value.private_dns_zone_networking.private_dns_resolver.name, { location = value.location })
      }
    }, null)
  } }
}
