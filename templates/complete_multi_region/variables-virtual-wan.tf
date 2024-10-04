variable "virtual_wan_name" {
  type        = string
  description = "The name of the virtual WAN"
  nullable    = false
}

variable "virtual_wan_settings" {
  type = object
  description = "The settings for the virtual WAN"
  default = null
}

variable "virtual_wan_virtual_hubs" {
  type = map(object({
    name                = optional(string, "vwan-hub-$${location}")
    location            = string
    resource_group_name = optional(string, "rg-vwan-hub-$${location}")
    virtual_network_connections = optional(object)
    firewall = optional(object({
      name     = optional(string, "fw-hub-$${location}")
      sku_name = string
      sku_tier = string
      zones    = optional(list(string))
      firewall_policy = object({
        name     = optional(string, "fwp-hub-$${location}")
        settings = object
      })
      settings = object
    }))
    address_prefix = string
    tags = optional(map(string))
    hub_routing_preference = optional(string)
    private_dns_zone_networking = optional(object({
      virtual_network = object({
        name = optional(string, "vnet-hub-dns-$${location}")
        address_space = string
        private_dns_resolver_subnet = object({
          name = optional(string, "subnet-hub-dns-$${location}")
          address_prefix = string
        })
      })
      private_dns_resolver = object({
        name = optional(string, "pdr-hub-dns-$${location}")
      })
    }))
  }))
  default     = {}
  description = "A map of virtual hubs to create. Detailed information about the virtual hub can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}