locals {
  private_dns_resolver_subnets = { for key, value in var.hub_virtual_networks : key => {
    dns_resolver = {
      hub_network_key  = key
      address_prefixes = [value.private_dns_zones.subnet_address_prefix]
      name             = value.private_dns_zones.subnet_name
      delegation = [{
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
    } } if can(value.bastion)
  }

  gateway_subnets = { for key, value in var.hub_virtual_networks : key => {
    gateway = {
      hub_network_key  = key
      address_prefixes = [value.virtual_network_gateways.subnet_address_prefix]
      name             = "GatewaySubnet"
    } } if can(value.virtual_network_gateways.express_route)
  }

  subnets = { for key, value in var.hub_virtual_networks : key => merge(local.private_dns_resolver_subnets[key], local.bastion_subnets[key], local.gateway_subnets[key]) }
}