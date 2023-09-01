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

variable "azure_location" {
  type    = string
}

variable "environment_name" {
  type   = string
}

variable "service_name" {
  type    = string
}

variable "postfix_number" {
  type = number
}

variable "resource_names" {
  type = map(string)
  default = {
    "resource_group_state" = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
    "resource_group_identity" = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
    "resource_group_agents" = "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
    "user_assigned_managed_identity" = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    "user_assigned_managed_identity_federated_credentials" = "Azure Landing Zone Federated Identity Credential" 
    "storage_account" = "sto{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}"
    "version_control_system_repository" = "{{service_name}}-{{environment_name}}"
    "version_control_system_service_connection" = "sc-{{service_name}}-{{environment_name}}"
    "version_control_system_environment" = "{{service_name}}-{{environment_name}}"
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