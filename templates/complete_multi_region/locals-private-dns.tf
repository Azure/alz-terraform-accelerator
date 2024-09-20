locals {
    private_dns_virtual_networks_hub_and_spoke_vnet = (local.hub_networking_enabled ? 
        { for virtual_network_key, virtual_network in module.hub_and_spoke_vnet[0].virtual_networks : virtual_network_key => { vnet_resource_id = virtual_network.id } } :
        {}
    )
    private_dns_virtual_networks_virtual_wan = (local.virtual_wan_enabled ? 
        { "virtual_wan" = { vnet_resource_id = module.virtual_network_private_dns.resource_id} } :
        {}
    )
    private_dns_virtual_networks = merge(local.private_dns_virtual_networks_hub_and_spoke_vnet, local.private_dns_virtual_networks_virtual_wan)
}