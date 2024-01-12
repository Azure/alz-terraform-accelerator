variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|1"
  type        = string
  default     = "basic"
}

variable "azure_devops_personal_access_token" {
  description = "The personal access token for Azure DevOps|2"
  type        = string
  sensitive   = true
}

variable "azure_devops_organization_name" {
  description = "The name of your Azure DevOps organization. This is the section of the url after 'dev.azure.com' or before '.visualstudio.com'. E.g. enter 'my-org' for 'https://dev.azure.com/my-org'|3"
  type        = string
}

variable "use_separate_repository_for_pipeline_templates" {
  description = "Controls whether to use a separate repository to store pipeline templates. This is an extra layer of security to ensure that the azure credentials can only be leveraged for the specified workload|4"
  type        = bool
  default     = true
}

variable "bootstrap_location" {
  description = "Azure Deployment location for the bootstrap resources (e.g. storage account, identities, etc)|4|azure_location"
  type        = string
}

variable "bootstrap_subscription_id" {
  description = "Azure Subscription ID for the bootstrap resources (e.g. storage account, identities, etc). Leave empty to use the az login subscription|6|azure_subscription_id"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Used to build up the default resource names (e.g. rg-<service_name>-mgmt-uksouth-001)|7|azure_name_section"
  type        = string
  default     = "alz"
}

variable "environment_name" {
  description = "Used to build up the default resource names (e.g. rg-alz-<environment_name>-uksouth-001)|8|azure_name_section"
  type        = string
  default     = "mgmt"
}

variable "postfix_number" {
  description = "Used to build up the default resource names (e.g. rg-alz-mgmt-uksouth-<postfix_number>)|9|number"
  type        = number
  default     = 1
}

variable "azure_devops_use_organisation_legacy_url" {
  description = "Use the legacy Azure DevOps URL (<organisation>.visualstudio.com) instead of the new URL (dev.azure.com/<organization>). This is ignored if an fqdn is supplied for version_control_system_organization|10|bool"
  type        = bool
  default     = false
}

variable "azure_devops_create_project" {
  description = "Create the Azure DevOps project if it does not exist|11|bool"
  type        = bool
  default     = true
}

variable "azure_devops_project_name" {
  description = "The name of the Azure DevOps project to use or create for the deployment|12"
  type        = string
}

variable "azure_devops_authentication_scheme" {
  type        = string
  description = "The authentication scheme to use for the Azure DevOps Pipelines|13|auth_scheme"
  validation {
    condition     = can(regex("^(ManagedServiceIdentity|WorkloadIdentityFederation)$", var.azure_devops_authentication_scheme))
    error_message = "azure_devops_authentication_scheme must be either ManagedServiceIdentity or WorkloadIdentityFederation"
  }
  default = "WorkloadIdentityFederation"
}

variable "use_self_hosted_agents" {
  description = "Controls whether to use self-hosted agents for the pipelines|14"
  type        = bool
  default     = true
}

variable "use_private_networking" {
  description = "Controls whether to use private networking for the agent to storage account communication|15"
  type        = bool
  default     = true
}

variable "allow_storage_access_from_my_ip" {
  description = "Allow access to the storage account from the current IP address. We recommend this is kept off for security|16"
  type        = bool
  default     = false
}

variable "apply_approvers" {
  description = "Apply stage approvers to the action / pipeline, must be a list of SPNs separate by a comma (e.g. abcdef@microsoft.com,ghijklm@microsoft.com)|17"
  type        = list(string)
  default     = []
}

variable "root_parent_management_group_display_name" {
  description = "The root parent management group display name. This default to 'Tenant Root Group' if not supplied|18"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|19"
  type        = list(string)
  default     = []
}

variable "agent_container_image" {
  description = "The container image to use for Azure DevOps Agents|hidden"
  type        = string
}

variable "target_subscriptions" {
  description = "The target subscriptions to apply owner permissions to|hidden_azure_subscription_ids"
  type        = list(string)
}

variable "module_folder_path" {
  description = "The folder for the starter modules|hidden"
  type        = string
}

variable "module_folder_path_relative" {
  description = "Whether the module folder path is relative to the bootstrap module|hidden"
  type        = bool
  default     = true
}

variable "pipeline_folder_path" {
  description = "The folder for the pipelines|hidden"
  type        = string
}

variable "pipeline_folder_path_relative" {
  description = "Whether the pipeline folder path is relative to the bootstrap module|hidden"
  type        = bool
  default     = true
}

variable "pipeline_files" {
  description = "The pipeline files to upload to the repository|hidden"
  type = map(object({
    pipeline_name           = string
    file_path               = string
    target_path             = string
    environment_keys        = list(string)
    service_connection_keys = list(string)
    agent_pool_keys         = list(string)
  }))
}

variable "pipeline_template_files" {
  description = "The pipeline template files to upload to the repository|hidden"
  type = map(object({
    file_path   = string
    target_path = string
  }))
}

variable "resource_names" {
  type        = map(string)
  description = "Overrides for resource names|hidden"
}

variable "agent_name_environment_variable" {
  description = "The agent name environment variable supplied to the container|hidden"
  type        = string
  default     = "AZP_AGENT_NAME"
}

variable "agent_pool_environment_variable" {
  description = "The agent pool environment variable supplied to the container|hidden"
  type        = string
  default     = "AZP_POOL"
}

variable "agent_organization_environment_variable" {
  description = "The agent organization environment variable supplied to the container|hidden"
  type        = string
  default     = "AZP_URL"
}

variable "agent_token_environment_variable" {
  description = "The agent token environment variable supplied to the container|hidden"
  type        = string
  default     = "AZP_TOKEN"
}

variable "virtual_network_address_space" {
  type        = string
  description = "The address space for the virtual network|hidden"
  default     = "10.0.0.0/24"
}

variable "virtual_network_subnet_address_prefix_container_instances" {
  type        = string
  description = "Address prefix for the virtual network subnet|hidden"
  default     = "10.0.0.0/26"
}

variable "virtual_network_subnet_address_prefix_storage" {
  type        = string
  description = "Address prefix for the virtual network subnet|hidden"
  default     = "10.0.0.64/26"
}
