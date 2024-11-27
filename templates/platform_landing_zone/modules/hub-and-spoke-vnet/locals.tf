locals {
  hub_virtual_networks = {
    for key, value in var.hub_virtual_networks : key => merge(value.hub_virtual_network, {
      ddos_protection_plan_id = local.ddos_protection_plan_enabled ? module.ddos_protection_plan[0].resource.id : try(value.hub_virtual_network.ddos_protection_plan_id, null)
      firewall = merge(value.hub_virtual_network.firewall, {
        firewall_policy = merge(value.hub_virtual_network.firewall.firewall_policy, {
          dns = merge(value.hub_virtual_network.firewall.firewall_policy.dns, {
            servers = can(value.private_dns_zones.resource_group_name) && can(value.hub_virtual_network.firewall) ? [local.private_dns_resolver_ip_addresses[key]] : try(value.hub_virtual_network.firewall.firewall_policy.dns.servers, null)
          })
        })
      })
      subnets = merge(local.subnets[key], value.hub_virtual_network.subnets)
    })
  }
}
