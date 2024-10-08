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

variable "virtual_hubs" {
  type = map(object({
    hub             = any
    firewall        = optional(any)
    firewall_policy = optional(any)
    private_dns_zones = optional(object({
      resource_group_name = string
      is_primary          = optional(bool, false)
      networking = object({
        virtual_network = object({
          name                = string
          address_space       = string
          resource_group_name = string
          private_dns_resolver_subnet = object({
            name           = string
            address_prefix = string
          })
        })
        private_dns_resolver = object({
          name                = string
          resource_group_name = string
        })
      })
    }))
  }))

  default     = {}
  description = <<DESCRIPTION
A map of virtual hubs to create.

The following attributes are supported:

  - hub: The virtual hub settings. Detailed information about the virtual hub can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub
  - firewall: (Optional) The firewall settings. Detailed information about the firewall can be found in the Virtual WAN module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub
  - firewall_policy: (Optional) The firewall policy settings. Detailed information about the firewall policy can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-firewall-policy
  - private_dns_zones: (Optional) The private DNS zone settings. Detailed information about the private DNS zone can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-network-private-link-private-dns-zones
    - resource_group_name: The resource group name where the private DNS zone will be created
    - is_primary: (Optional) Flag to indicate if the private DNS zone is primary. If set to true, only the regional DNS zones will be created
    - networking: The networking settings for the private DNS zone. This is required for Virtual WAN since private DNS zones cannot be linked to a virtual hub.
      - virtual_network: The virtual network settings for the private DNS zone
        - name: The name of the virtual network
        - address_space: The address space of the virtual network
        - resource_group_name: The resource group name where the virtual network is located
        - private_dns_resolver_subnet: The private DNS resolver subnet settings
          - name: The name of the subnet
          - address_prefix: The address prefix of the subnet
      - private_dns_resolver: The private DNS resolver settings for the private DNS zone. This is required for Virtual WAN since private DNS zones cannot be linked to a virtual hub.
        - name: The name of the private DNS resolver
        - resource_group_name: The resource group name where the private DNS resolver is located

DESCRIPTION
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
