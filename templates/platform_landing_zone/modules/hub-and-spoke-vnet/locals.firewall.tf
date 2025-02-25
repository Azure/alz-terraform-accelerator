locals {
  firewall_enabled = { for key, value in var.hub_virtual_networks : key => try(value.hub_virtual_network.firewall, null) != null }

  firewall_policy_dns_defaults = { for key, value in var.hub_virtual_networks : key => local.private_dns_zones_enabled[key] && local.firewall_enabled[key] ? {
    proxy_enabled = true
    servers       = [local.private_dns_resolver_ip_addresses[key]]
  } : null }

  firewall_policies = { for key, value in var.hub_virtual_networks : key => local.firewall_enabled[key] ? merge(value.hub_virtual_network.firewall.firewall_policy, {
    dns = try(value.hub_virtual_network.firewall.firewall_policy.dns, local.firewall_policy_dns_defaults[key])
  }) : null }

  firewalls = { for key, value in var.hub_virtual_networks : key => local.firewall_enabled[key] ? merge(value.hub_virtual_network.firewall, {
    firewall_policy = local.firewall_policies[key]
  }) : null }
}
