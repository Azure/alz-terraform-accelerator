locals {
  hub_virtual_networks = {
    for key, value in var.hub_virtual_networks : key => merge(value.hub_virtual_network, {
      ddos_protection_plan_id         = local.ddos_protection_plan_enabled ? module.ddos_protection_plan[0].resource.id : try(value.hub_virtual_network.ddos_protection_plan_id, null)
      resource_group_creation_enabled = try(value.hub_virtual_network.resource_group_creation_enabled, false)
      resource_group_lock_enabled     = try(value.hub_virtual_network.resource_group_lock_enabled, false)
      mesh_peering_enabled            = try(value.hub_virtual_network.mesh_peering_enabled, true)
      firewall = try(value.hub_virtual_network.firewall, null) == null ? null : merge(value.hub_virtual_network.firewall, {
        firewall_policy = merge(value.hub_virtual_network.firewall.firewall_policy, {
          dns = merge({
            proxy_enabled = can(value.private_dns_zones.resource_group_name) && can(value.hub_virtual_network.firewall) ? true : try(value.hub_virtual_network.firewall.firewall_policy.dns.proxy_enabled, false)
            servers       = can(value.private_dns_zones.resource_group_name) && can(value.hub_virtual_network.firewall) ? [local.private_dns_resolver_ip_addresses[key]] : try(value.hub_virtual_network.firewall.firewall_policy.dns.servers, null)
          }, try(value.hub_virtual_network.firewall.firewall_policy.dns, {}))
        })
      })
      subnets = merge(local.subnets[key], value.hub_virtual_network.subnets)
    })
  }
}
