variable "resource_group_name" {
  type        = string
  nullable    = false
  description = "The name of the resource group for private DNS zones"
}

variable "locations" {
  type = map(object({
    location   = string
    is_primary = optional(bool, false)
  }))
  nullable    = false
  description = "A map of locations to create private DNS zones"
}

variable "connected_virtual_networks" {
  type = map(object({
    vnet_resource_id = string
  }))
  nullable    = false
  description = "A map of virtual networks to attach the private DNS zones to"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the private DNS zones"
}
