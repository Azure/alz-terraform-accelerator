locals {
  const = {
    connectivity = {
      virtual_wan = "virtual_wan"
      hub_and_spoke_vnet = "hub_and_spoke_vnet"
      none = "none"
    }
  }
}

locals {
  connectivity_virtual_wan_enabled = var.connectivity_type == const.connectivity.virtual_wan
  connectivity_hub_and_spoke_vnet_enabled = var.connectivity_type == const.connectivity.hub_and_spoke_vnet
  connectivity_none_enabled = var.connectivity_type == const.connectivity.none
}
