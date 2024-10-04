variable "management_use_vnext" {
  type        = bool
  default     = false
  description =  "Flag to enable/disable the use of the next version of the management module"
}

variable "management_resource_group_name" {
  type        = string
  description = "The name of the resource group for the management resources"
  default = "rg-management-$${location}"
}

variable "management_log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics workspace for the management resources"
  default = "law-management-$${location}"
}

variable "management_automation_account_name" {
  type        = string
  description = "The SKU of the Log Analytics workspace for the management resources"
  default = "aa-management-$${location}"
}

variable "management_settings" {
  type = any
  default = null
}