locals {
  virtual_wan_virtual_network_connections_input = try(local.module_virtual_wan.virtual_network_connections, {})
  virtual_wan_private_dns_virtual_network_connections = { for key, value in try(local.module_virtual_wan.virtual_hub, {}) : "private_dns_vnet_${key}" => {
    virtual_hub_key           = key
    remote_virtual_network_id = module.virtual_network_private_dns[key].resource_id
  } }
  virtual_wan_virtual_network_connections = local.virtual_wan_enabled ? merge(local.virtual_wan_virtual_network_connections_input, local.virtual_wan_private_dns_virtual_network_connections) : {}
  virtual_wan_firewalls = { for key, value in try(local.module_virtual_wan.firewalls, {}) : key => {
    virtual_hub_key   = value.virtual_hub_key
    name              = value.name
    sku_name          = value.sku_name
    sku_tier          = value.sku_tier
    firwall_policy_id = module.firewall_policy[key].resource_id
    tags              = try(value.tags, null)
  } }
}