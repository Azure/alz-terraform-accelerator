variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|starter_module"
  type        = string
  default     = "basic"
}

variable "version_control_system_access_token" {
  description = "The personal access token for the version control system to use for the deployment|azure_name"
  type        = string
  sensitive   = true
}

variable "version_control_system_organization" {
  description = "The organization for the version control system to use for the deployment|azure_name"
  type        = string
}

variable "azure_location" {
  description = "Azure Deployment location for the landing zone management resources|azure_location"
  type        = string
}

variable "service_name" {
  description = "Used to build up the default resource names (e.g. rg-<service_name>-mgmt-uksouth-001)|azure_name_section"
  type        = string
  default     = "alz"
}

variable "environment_name" {
  description = "Used to build up the default resource names (e.g. rg-alz-<environment_name>-uksouth-001)|azure_name_section"
  type        = string
  default     = "mgmt"
}

variable "postfix_number" {
  description = "Used to build up the default resource names (e.g. rg-alz-mgmt-uksouth-<postfix_number>)|number"
  type        = number
  default     = 1
}

variable "azure_devops_use_organisation_legacy_url" {
  description = "Use the legacy Azure DevOps URL (<organisation>.visualstudio.com) instead of the new URL (dev.azure.com/<organization>)|bool"
  type        = bool
  default     = false
}

variable "azure_devops_create_project" {
  description = "Create the Azure DevOps project if it does not exist|bool"
  type        = bool
  default     = true
}

variable "azure_devops_project_name" {
  description = "The name of the Azure DevOps project to use or create for the deployment|azure_name"
  type        = string
}

variable "azure_devops_authentication_scheme" {
  type        = string
  description = "The authentication scheme to use for the Azure DevOps Pipelines|auth_scheme"
  validation {
    condition     = can(regex("^(ManagedServiceIdentity|WorkloadIdentityFederation)$", var.azure_devops_authentication_scheme))
    error_message = "azure_devops_authentication_scheme must be either ManagedServiceIdentity or WorkloadIdentityFederation"
  }
  default = "WorkloadIdentityFederation"
}

variable "apply_approvers" {
  description = "Apply stage approvers to the action / pipeline, must be a list of SPNs separate by a comma (e.g. abcdef@microsoft.com,ghijklm@microsoft.com)"
  type        = list(string)
}

variable "agent_container_image" {
  description = "The container image to use for Azure DevOps Agents|hidden"
  type        = string
}

variable "target_subscriptions" {
  description = "The target subscriptions to apply onwer permissions to|hidden"
  type        = list(string)
}

variable "template_folder_path" {
  description = "The folder for the templates|hidden"
  type        = string
}

variable "ci_cd_module" {
  description = "The folder for the ci/cd module|hidden"
  type        = string
}

variable "resource_names" {
  type        = map(string)
  description = "Overrides for resource names|hidden"
  default = {
    resource_group_state                                 = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
    resource_group_identity                              = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
    resource_group_agents                                = "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
    user_assigned_managed_identity                       = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    user_assigned_managed_identity_federated_credentials = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    storage_account                                      = "sto{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}{{random_string}}"
    storage_container                                    = "{{environment_name}}-tfstate"
    container_instance_01                                = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    container_instance_02                                = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_one}}"
    agent_01                                             = "agent-{{service_name}}-{{environment_name}}-{{postfix_number}}"
    agent_02                                             = "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_one}}"
    version_control_system_repository                    = "{{service_name}}-{{environment_name}}"
    version_control_system_service_connection            = "sc-{{service_name}}-{{environment_name}}"
    version_control_system_environment_plan              = "{{service_name}}-{{environment_name}}-plan"
    version_control_system_environment_apply             = "{{service_name}}-{{environment_name}}-apply"
    version_control_system_variable_group                = "{{service_name}}-{{environment_name}}"
    version_control_system_agent_pool                    = "{{service_name}}-{{environment_name}}"
  }
}