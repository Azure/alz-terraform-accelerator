output "private_link_private_dns_zone_virtual_network_link_moved_blocks" {
  description = <<DESCRIPTION
Moved blocks for the Private Link Private DNS Zone Virtual Network Links.

NOTE: This is a temporary output to support migration to the new module and will be removed in the next major version.
DESCRIPTION
  value = (var.private_link_private_dns_zone_virtual_network_link_moved_blocks_enabled && local.connectivity_enabled ?
    (local.connectivity_virtual_wan_enabled ?
      module.virtual_wan[0].private_link_private_dns_zone_virtual_network_link_moved_blocks :
    module.hub_and_spoke_vnet[0].private_link_private_dns_zone_virtual_network_link_moved_blocks)
  : null)
}
