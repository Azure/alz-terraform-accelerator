variable "starter_locations" {
  type        = list(string)
  description = "The default for Azure resources. (e.g 'uksouth')|azure_location"
}

variable "subscription_id_connectivity" {
  type        = string
  description = "value of the subscription id for the Connectivity subscription|azure_subscription_id"
}

variable "subscription_id_identity" {
  type        = string
  description = "value of the subscription id for the Identity subscription|azure_subscription_id"
}

variable "subscription_id_management" {
  type        = string
  description = "value of the subscription id for the Management subscription|azure_subscription_id"
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group|azure_name"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}

variable "custom_replacements" {
  type = object({
    names                      = optional(map(string), {})
    resource_group_identifiers = optional(map(string), {})
    resource_identifiers       = optional(map(string), {})
  })
  description = "Custom replacements"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "connectivity_resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
  default     = {}
  description = <<DESCRIPTION
A map of resource groups to create. These must be created before the connectivity module is applied.

The following attributes are supported:

  - name: The name of the resource group
  - location: The location of the resource group

DESCRIPTION
}

variable "hub_and_spoke_vnet_settings" {
  type    = any
  default = {}
}

variable "hub_and_spoke_vnet_virtual_networks" {
  type    = any
  default = {}
}

variable "virtual_wan_settings" {
  type    = any
  default = {}
}

variable "virtual_wan_virtual_hubs" {
  type    = any
  default = {}
}

variable "management_resource_settings" {
  type    = any
  default = {}
}

variable "management_group_settings" {
  type    = any
  default = {}
}
