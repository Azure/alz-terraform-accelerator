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