variable "version_control_system" {
  type    = string
  description = "Whether to target github or azuredevops"
  validation {
    condition     = can(regex("^(github|azuredevops)$", var.version_control_system))
    error_message = "version_control_system must be either github or azuredevops"
  }
}

variable "version_control_system_access_token" {
  type      = string
  sensitive = true
}

variable "version_control_system_organization" {
  type = string
}

variable "version_control_repository_name" {
  type = string
}

variable "azure_location" {
  type    = string
}

variable "azure_service_name" {
  type    = string
}

variable "azure_environment_name" {
  type   = string
}

variable "azure_postfix_number" {
  type = number
}

variable "azure_resource_names" {
  type = map(string)
  default = {
    "resource_group_state" = "rg-{{azure_service_name}}-{{azure_environment_name}}-state-{{azure_location}}-{{azure_postfix_number}}"
    "resource_group_identity" = "rg-{{azure_service_name}}-{{azure_environment_name}}-identity-{{azure_location}}-{{azure_postfix_number}}"
    "resource_group_agents" = "rg-{{azure_service_name}}-{{azure_environment_name}}-agents-{{azure_location}}-{{azure_postfix_number}}"
    "user_assigned_managed_identity" = "id-{{azure_service_name}}-{{azure_environment_name}}-{{azure_location}}-{{azure_postfix_number}}"
    "storage_account" = "kv-{{azure_service_name}}-{{azure_environment_name}}-{{azure_location}}-{{azure_postfix_number}}"
  }
}

variable "azure_devops_use_organisation_legacy_url" {
  type    = bool
}

variable "azure_devops_create_project" {
  type    = bool
}

variable "azure_devops_project_name" {
  type = string
}

variable "azure_devops_authentication_scheme" {
  type = string
  validation {
    condition     = can(regex("^(ManagedIdentity|WorkloadIdentityFederation)$", var.azure_devops_authentication_scheme))
    error_message = "azure_devops_authentication_scheme must be either ManagedIdentity or WorkloadIdentityFederation"
  }
}