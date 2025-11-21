variable "private_link_private_dns_zone_virtual_network_link_moved_blocks_enabled" {
  description = <<DESCRIPTION
Enable or disable the creation of Private Link Private DNS Zone Virtual Network Link moved blocks.

NOTE: This is a temporary variable to support migration to the new module and will be moved in the next major version.
DESCRIPTION
  type        = bool
  default     = false
}