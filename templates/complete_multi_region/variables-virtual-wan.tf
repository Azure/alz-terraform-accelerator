variable "virtual_wan_settings" {
  type    = any
  default = {}
}

variable "virtual_wan_virtual_hubs" {
  type = map(object({
    hub               = any
    firewall          = optional(any)
    private_dns_zones = optional(any)
  }))
  default     = {}
  description = "A map of virtual hubs to create. Detailed information about the virtual hub can be found in the module's README: https://registry.terraform.io/modules/Azure/avm-ptn-virtualhub"
}
