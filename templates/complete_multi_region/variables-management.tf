variable "management_use_avm" {
  type        = bool
  default     = false
  description = "Flag to enable/disable the use of the AVM version of the management modules"
}

variable "management_settings_avm" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management groups and management resources. Details of the settings will be added later.
DESCRIPTION
}

variable "management_settings_es" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management groups and management resources. Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/caf-enterprise-scale
DESCRIPTION
}
