variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|1"
  type        = string
  default     = "basic"
}

variable "version_control_system_access_token" {
  description = "The personal access token for the version control system to use for the deployment|2"
  type        = string
  sensitive   = true
}

variable "version_control_system_organization" {
  description = "The organization for the version control system to use for the deployment (supply a fqdn e.g. https://vcs.company.com/my-org to use a self-hosted Azure DevOps Server)|3"
  type        = string
}

variable "azure_location" {
  description = "Azure Deployment location for the landing zone management resources|4|azure_location"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID for the landing zone management resources. Leave empty to use the az login subscription|5|azure_subscription_id"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Used to build up the default resource names (e.g. rg-<service_name>-mgmt-uksouth-001)|6|azure_name_section"
  type        = string
  default     = "alz"
}

variable "environment_name" {
  description = "Used to build up the default resource names (e.g. rg-alz-<environment_name>-uksouth-001)|7|azure_name_section"
  type        = string
  default     = "mgmt"
}

variable "postfix_number" {
  description = "Used to build up the default resource names (e.g. rg-alz-mgmt-uksouth-<postfix_number>)|8|number"
  type        = number
  default     = 1
}

variable "azure_devops_use_organisation_legacy_url" {
  description = "Use the legacy Azure DevOps URL (<organisation>.visualstudio.com) instead of the new URL (dev.azure.com/<organization>). This is ignored if an fqdn is supplied for version_control_system_organization|9|bool"
  type        = bool
  default     = false
}

variable "azure_devops_create_project" {
  description = "Create the Azure DevOps project if it does not exist|10|bool"
  type        = bool
  default     = true
}

variable "azure_devops_project_name" {
  description = "The name of the Azure DevOps project to use or create for the deployment|11"
  type        = string
}

variable "azure_devops_authentication_scheme" {
  type        = string
  description = "The authentication scheme to use for the Azure DevOps Pipelines|12|auth_scheme"
  validation {
    condition     = can(regex("^(ManagedServiceIdentity|WorkloadIdentityFederation)$", var.azure_devops_authentication_scheme))
    error_message = "azure_devops_authentication_scheme must be either ManagedServiceIdentity or WorkloadIdentityFederation"
  }
  default = "WorkloadIdentityFederation"
}

variable "apply_approvers" {
  description = "Apply stage approvers to the action / pipeline, must be a list of SPNs separate by a comma (e.g. abcdef@microsoft.com,ghijklm@microsoft.com)|13"
  type        = list(string)
  default     = []
}

variable "root_management_group_display_name" {
  description = "The root management group display name|14"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|15"
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
}
