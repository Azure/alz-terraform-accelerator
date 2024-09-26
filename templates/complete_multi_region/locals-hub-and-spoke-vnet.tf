locals {
  vnet_gateway_default_skus = { for key, value in local.module_virtual_network_gateway : key => length(local.regions[value.location].zones) == 0 ? "Standard" : "ErGw1AZ" }
}
