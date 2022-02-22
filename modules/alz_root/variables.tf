variable "sub_id_connectivity" {
  description = "Subscription ID of the identity subscription"
  type        = string
  validation {
    condition     = can(regex("^[a-f\\d]{4}(?:[a-f\\d]{4}-){4}[a-f\\d]{12}$", var.sub_id_connectivity))
    error_message = "The value must be a Subscription ID (GUID)."
  }
}

variable "sub_id_identity" {
  description = "Subscription ID of the identity subscription"
  type        = string
  validation {
    condition     = can(regex("^[a-f\\d]{4}(?:[a-f\\d]{4}-){4}[a-f\\d]{12}$", var.sub_id_identity))
    error_message = "The value must be a Subscription ID (GUID)."
  }
}

variable "sub_id_management" {
  description = "Subscription ID of the identity subscription"
  type        = string
  validation {
    condition     = can(regex("^[a-f\\d]{4}(?:[a-f\\d]{4}-){4}[a-f\\d]{12}$", var.sub_id_management))
    error_message = "The value must be a Subscription ID (GUID)."
  }
}

variable "root_id" {
  type = string
}

variable "root_name" {
  type = string
}

variable "primary_location" {
  type = string
}

variable "secondary_location" {
  type = string
}

variable "email_security_contact" {
  type = string
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["canary", "prod", ], var.environment)
    error_message = "Value must be either 'canary' or 'prod'."
  }
}
