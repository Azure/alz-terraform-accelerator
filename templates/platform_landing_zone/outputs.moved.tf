output "private_link_private_dns_zone_virtual_network_link_moved_block_template_module_prefix" {
  description = "The module prefix for the Private Link Private DNS Zone Virtual Network Link moved block template."
  value = (var.private_link_private_dns_zone_virtual_network_link_moved_blocks_enabled && local.connectivity_enabled ?
    (local.connectivity_virtual_wan_enabled ?
      module.virtual_wan[0].private_link_private_dns_zone_virtual_network_link_moved_block_template_module_prefix :
    module.hub_and_spoke_vnet[0].private_link_private_dns_zone_virtual_network_link_moved_block_template_module_prefix)
  : null)
}
