variable "starter_locations" {
  type        = list(string)
  description = "The default for Azure resources. (e.g 'uksouth')"
  validation {
    condition     = length(var.starter_locations) > 0
    error_message = "You must provide at least one starter location region."
  }
  validation {
    condition     = var.connectivity_type == "none" || ((length(var.virtual_wan_virtual_hubs) <= length(var.starter_locations)) || (length(var.hub_and_spoke_vnet_virtual_networks) <= length(var.starter_locations)))
    error_message = "The number of regions supplied in `starter_locations` must match the number of regions specified for connectivity."
  }
}

variable "subscription_id_connectivity" {
  type        = string
  description = "value of the subscription id for the Connectivity subscription"
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.subscription_id_connectivity))
    error_message = "You must provide a valid GUID for the Connectivity subscription ID."
  }
}

variable "subscription_id_identity" {
  type        = string
  description = "value of the subscription id for the Identity subscription"
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.subscription_id_identity))
    error_message = "You must provide a valid GUID for the Identity subscription ID."
  }
}

variable "subscription_id_management" {
  type        = string
  description = "value of the subscription id for the Management subscription"
  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.subscription_id_management))
    error_message = "You must provide a valid GUID for the Management subscription ID."
  }
}

variable "root_parent_management_group_id" {
  type        = string
  default     = ""
  description = "This is the id of the management group that the ALZ hierarchy will be nested under, will default to the Tenant Root Group"
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
  default = {
    names                      = {}
    resource_group_identifiers = {}
    resource_identifiers       = {}
  }
  description = "Custom replacements"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
