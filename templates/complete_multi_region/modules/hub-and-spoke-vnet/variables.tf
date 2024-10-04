variable "hub_virtual_networks" {
  type = map(object({
    location            = string
    hub_virtual_network = any
    virtual_network_gateways = optional(object({
      express_route = optional(any)
      vpn = optional(any)
    }))
  }))
  default     = {}
  description = "A map of hub networks to create. Detailed information about the hub network can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking"
}

variable "enable_telemetry" {
  default     = true
  type        = bool
  description = "Flag to enable/disable telemetry"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags to add to the private DNS zones"
}
