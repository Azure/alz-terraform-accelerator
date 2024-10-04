locals {
  virtual_network_connections_input = { for virtual_network_connection in flatten([ for virtual_hub_key, virtual_hub_value in var.virtual_hubs :
    [ for virtual_network_connection_key, virtual_network_connection_value in value.virtual_network_connections : {
      unique_key                = "${virtual_hub_key}-${virtual_network_connection_key}"
      name                      = virtual_network_connection_value.settings.name
      virtual_hub_key           = virtual_hub_key
      remote_virtual_network_id = virtual_network_connection_value.remote_virtual_network_id
      settings                  = virtual_network_connection_value.settings
    } ]
  ]) : virtual_network_connection.unique_key => {
    name                      = virtual_network_connection.name
    virtual_hub_key           = virtual_network_connection.virtual_hub_key
    remote_virtual_network_id = virtual_network_connection.remote_virtual_network_id
    settings                  = virtual_network_connection.settings
  } }
    
  virtual_network_connections_private_dns = var.private_dns_zones_enabled ? { for key, value in try(local.module_virtual_wan.virtual_hubs, {}) : "private_dns_vnet_${key}" => {
    name                      = "private_dns_vnet_${key}"
    virtual_hub_key           = key
    remote_virtual_network_id = module.virtual_network_private_dns[key].resource_id
  } } : {}

  virtual_network_connections = merge(local.virtual_network_connections_input, local.virtual_network_connections_private_dns)
}
  
locals {
  firewall_policies = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => {
      virtual_hub_key    = virtual_hub_value.firewall.virtual_hub_key
      name                = virtual_hub_value.firewall.firewall_policy.name
      location            = virtual_hub_value.location
      resource_group_name = virtual_hub_value.resource_group == null ? var.resource_group_name : virtual_hub_value.resource_group
      settings   = virtual_hub_value.firewall.firewall_policysettings
    } if can(virtual_hub_value.firewall.firewall_policy)
  }

  firewalls = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => {
      virtual_hub_key    = virtual_hub_value.firewall.virtual_hub_key
      name               = virtual_hub_value.firewall.name
      sku_name           = virtual_hub_value.firewall.sku_name
      sku_tier           = virtual_hub_value.firewall.sku_tier
      dns_servers       = try(virtual_hub_value.firewall.settings.dns_servers, null)
      private_ip_ranges    = try(virtual_hub_value.firewall.settings.private_ip_ranges, null)
      threat_intel_mode    = try(virtual_hub_value.firewall.settings.threat_intel_mode, null)
      zones                = virtual_hub_value.firewall.zones
      vhub_public_ip_count = try(virtual_hub_value.firewall.settings.vhub_public_ip_count, null)
      tags                 = try(virtual_hub_value.firewall.settings.tags, null)
      default_ip_configuration = try(virtual_hub_value.firewall.default_ip_configuration, null)
      management_ip_configuration = try(virtual_hub_value.firewall.management_ip_configuration, null)
      ip_configuration = try(virtual_hub_value.firewall.ip_configuration, null)
      firewall_policy_id = module.firewall_policy[virtual_hub_key].resource_id
    } if can(virtual_hub_value.firewall)
  }
}
