variable "virtual_wan_settings" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The shared settings for the Virtual WAN. This is where global resources are defined.

The following attributes are supported:

  - ddos_protection_plan: (Optional) The DDoS protection plan settings. Detailed information about the DDoS protection plan can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-ddosprotectionplan
  
The Virtual WAN module attributes are also supported. Detailed information about the Virtual WAN module variables can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan

DESCRIPTION
}

variable "virtual_wan_virtual_hubs" {
  type = map(object({
    hub               = any
    firewall          = optional(any)
    firewall_policy   = optional(any)
    private_dns_zones = optional(any)
    bastion           = optional(any)
    virtual_network_gateways = optional(object({
      express_route = optional(any)
      vpn           = optional(any)
    }))
    side_car_virtual_network = optional(any)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of virtual hubs to create.

The following attributes are supported:

  - hub: The virtual hub settings. Detailed information about the virtual hub can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub
  - firewall: (Optional) The firewall settings. Detailed information about the firewall can be found in the Virtual WAN module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub
  - firewall_policy: (Optional) The firewall policy settings. Detailed information about the firewall policy can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-firewall-policy
  - private_dns_zones: (Optional) The private DNS zone settings. Detailed information about the private DNS zone can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-network-private-link-private-dns-zones
  - bastion: (Optional) The bastion host settings. Detailed information about the bastion can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-res-network-bastionhost/
  - virtual_network_gateways: (Optional) The virtual network gateway settings. Detailed information about the virtual network gateway can be found in the Virtual WAN module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub
  - side_car_virtual_network: (Optional) The side car virtual network settings. Detailed information about the side car virtual network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork

DESCRIPTION
}
