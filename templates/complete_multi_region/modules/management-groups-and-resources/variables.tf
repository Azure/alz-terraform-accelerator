variable "location" {
  type        = string
  description = "The location of the resource group"
  nullable = false
}

variable "settings" {
  type        = any
  description = "The settings for the management groups and resources"
  default = null
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Flag to enable/disable telemetry"
}
