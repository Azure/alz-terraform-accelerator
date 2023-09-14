variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|1|starter_module"
  type        = string
  default     = "basic"
}

variable "version_control_system_access_token" {
  description = "The personal access token for the version control system to use for the deployment|2|azure_name"
  type        = string
  sensitive   = true
}

variable "version_control_system_organization" {
  description = "The organization for the version control system to use for the deployment|3|azure_name"
  type        = string
}

variable "azure_location" {
  description = "Azure Deployment location for the landing zone management resources|4|azure_location"
  type        = string
}

variable "service_name" {
  description = "Used to build up the default resource names (e.g. rg-<service_name>-mgmt-uksouth-001)|5|azure_name_section"
  type        = string
  default     = "alz"
}

variable "environment_name" {
  description = "Used to build up the default resource names (e.g. rg-alz-<environment_name>-uksouth-001)|6|azure_name_section"
  type        = string
  default     = "mgmt"
}

variable "postfix_number" {
  description = "Used to build up the default resource names (e.g. rg-alz-mgmt-uksouth-<postfix_number>)|7|number"
  type        = number
  default     = 1
}

variable "apply_approvers" {
  description = "Apply stage approvers to the action / pipeline, must be a list of SPNs separate by a comma (e.g. abcdef@microsoft.com,ghijklm@microsoft.com)|8"
  type        = list(string)
  default     = []
}

variable "repository_visibility" {
  description = "The visibility of the repository. Must be 'public' if your organization is not licensed|9|repo_visibility"
  type = string
} 

variable "target_subscriptions" {
  description = "The target subscriptions to apply onwer permissions to|hidden_azure_subscription_ids"
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