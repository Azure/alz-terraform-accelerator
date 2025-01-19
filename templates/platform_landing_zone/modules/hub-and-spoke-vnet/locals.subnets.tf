locals {
  private_dns_resolver_subnets = { for key, value in var.hub_virtual_networks : key => {
    dns_resolver = {
      hub_network_key  = key
      address_prefixes = [value.private_dns_zones.subnet_address_prefix]
      name             = value.private_dns_zones.subnet_name
      route_table = {
        assign_generated_route_table = false
      }
      delegations = [{
        name = "Microsoft.Network.dnsResolvers"
        service_delegation = {
          name = "Microsoft.Network/dnsResolvers"
        }
      }]
    } } if local.private_dns_zones_enabled[key]
  }

  bastion_subnets = { for key, value in var.hub_virtual_networks : key => {
    bastion = {
      hub_network_key  = key
      address_prefixes = [value.bastion.subnet_address_prefix]
      name             = "AzureBastionSubnet"
      route_table = {
        assign_generated_route_table = false
      }
    } } if local.bastions_enabled[key]
  }

  gateway_subnets = { for key, value in var.hub_virtual_networks : key => {
    gateway = {
      hub_network_key  = key
      address_prefixes = [value.virtual_network_gateways.subnet_address_prefix]
      name             = "GatewaySubnet"
      route_table = {
        assign_generated_route_table = false
      }
    } } if try(value.virtual_network_gateways, null) != null && (can(value.virtual_network_gateways.express_route) || can(value.virtual_network_gateways.vpn))
  }

  subnets = { for key, value in var.hub_virtual_networks : key => merge(lookup(local.private_dns_resolver_subnets, key, {}), lookup(local.bastion_subnets, key, {}), lookup(local.gateway_subnets, key, {})) }
}
