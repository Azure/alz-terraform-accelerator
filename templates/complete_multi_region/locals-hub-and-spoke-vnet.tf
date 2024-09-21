locals {
  vnet_gateway_default_skus = { for key, value in local.module_virtual_network_gateway : key => local.regions[value.location].zones == [] ? "Standard" : "ErGw1AZ" }
}
