locals {
  firewall_policies = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => merge({
    location            = try(virtual_hub_value.firewall.firewall_policy.location, virtual_hub_value.hub.location)
    resource_group_name = try(virtual_hub_value.firewall.firewall_policy.resource_group_name, virtual_hub_value.hub.resource_group)
    dns = {
      servers       = [module.dns_resolver[virtual_hub_key].inbound_endpoint_ips["dns"]]
      proxy_enabled = true
    }
  }, virtual_hub_value.firewall.firewall_policy) if can(virtual_hub_value.firewall_policy) }

  firewalls = { for virtual_hub_key, virtual_hub_value in var.virtual_hubs : virtual_hub_key => merge(
    {
      virtual_hub_key    = virtual_hub_key
      location           = try(virtual_hub_value.firewall.location, virtual_hub_value.hub.location)
      firewall_policy_id = module.firewall_policy[virtual_hub_key].resource_id
    }, virtual_hub_value.firewall)
    if can(virtual_hub_value.firewall)
  }
}