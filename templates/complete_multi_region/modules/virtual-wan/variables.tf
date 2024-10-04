variable "name" {
  type        = string
  description = "The name of the virtual WAN"
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the virtual WAN"
  nullable    = false
}

variable "location" {
  type        = string
  description = "A map of locations to create the virtual WAN"
  nullable    = false
}

variable "private_dns_zones_enabled" {
  type        = bool
  description = "Flag to enable/disable private DNS zones"
  default     = true
}

variable "settings" {
  type        = any
  description = "The settings for the virtual WAN"
  default     = null
}

variable "virtual_hubs" {
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    virtual_network_connections = optional(map(any))
    firewall = optional(object({
      name     = string
      sku_name = string
      sku_tier = string
      zones    = optional(list(string))
      firewall_policy = object({
        name     = string
        settings = optional(any)
      })
      settings = optional(any)
    }))
    address_prefix         = string
    tags                   = optional(map(string))
    hub_routing_preference = optional(string)
    private_dns_zone_networking = optional(object({
      virtual_network = object({
        name          = string
        address_space = string
        private_dns_resolver_subnet = object({
          name           = string
          address_prefix = string
        })
      })
      private_dns_resolver = object({
        name = string
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