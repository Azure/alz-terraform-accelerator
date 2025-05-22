variable "connectivity_type" {
  type        = string
  description = "The type of network connectivity technology to use for the private DNS zones"
  default     = "hub_and_spoke_vnet"
  validation {
    condition     = contains(values(local.const.connectivity), var.connectivity_type)
    error_message = "The connectivity type must be either 'hub_and_spoke_vnet', 'virtual_wan' or 'none'"
  }
}

variable "connectivity_resource_groups" {
  type = map(object({
    enabled  = optional(bool, true)
    name     = string
    location = string
  }))
  default     = {}
  description = <<DESCRIPTION
A map of resource groups to create. These must be created before the connectivity module is applied.

The following attributes are supported:

  - enabled: (Optional) A boolean value that indicates whether the resource group should be created. Defaults to true.
  - name: The name of the resource group
  - location: The location of the resource group

DESCRIPTION
}
