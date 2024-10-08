variable "management_use_avm" {
  type        = bool
  default     = false
  description = "Flag to enable/disable the use of the AVM version of the management modules"
}

variable "management_settings_avm" {
  type    = any
  default = {}
}

variable "management_settings_es" {
  type    = any
  default = {}
}
