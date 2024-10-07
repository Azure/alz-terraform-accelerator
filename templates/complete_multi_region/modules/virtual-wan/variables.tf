variable "virtual_wan_settings" {
  type = any
}

variable "virtual_hubs" {
  type = map(object({
    hub = any
    firewall = optional(any)
    firewall_policy = optional(any)
    private_dns_zones = optional(object({
      resource_group_name = string
      is_primary          = optional(bool, false)
      networking = object({
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

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags to add to the private DNS zones"
}
