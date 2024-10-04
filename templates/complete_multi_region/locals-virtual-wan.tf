locals {
  virtual_wan_virtual_hubs = { for key, value in var.virtual_wan_virtual_hubs : key => {
    location = value.location
    sku      = value.sku
    tags     = value.tags
    firewall = value.firewall
  } }
}
