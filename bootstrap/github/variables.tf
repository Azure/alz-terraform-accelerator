variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|1|starter_module"
  type        = string
  default     = "basic"
}

variable "version_control_system_access_token" {
  description = "The personal access token for the version control system to use for the deployment|2"
  type        = string
  sensitive   = true
}

variable "version_control_system_organization" {
  description = "The organization for the version control system to use for the deployment (supply a fqdn e.g. https://vcs.company.com/my-org to use a self-hosted GitHub Enterprise Server)|3"
  type        = string
}

variable "version_control_system_use_separate_repository_for_templates" {
  description = "Controls whether to use a separate repository to store action templates. This is an extra layer of security to ensure that the azure credentials can only be leveraged for the specified workload|4"
  type        = bool
  default     = true
}

variable "azure_location" {
  description = "Azure Deployment location for the landing zone management resources|5|azure_location"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID for the landing zone management resources. Leave empty to use the az login subscription|6|azure_subscription_id"
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

variable "apply_approvers" {
  description = "Apply stage approvers to the action / pipeline, must be a list of SPNs separate by a comma (e.g. abcdef@microsoft.com,ghijklm@microsoft.com)|10"
  type        = list(string)
  default     = []
}

variable "repository_visibility" {
  description = "The visibility of the repository. Must be 'public' if your organization is not licensed|11|repo_visibility"
  type        = string
  default     = "private"
}

variable "root_management_group_display_name" {
  description = "The root management group display name|12"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|13"
  type        = list(string)
  default     = []
}

variable "target_subscriptions" {
  description = "The target subscriptions to apply onwer permissions to|hidden_azure_subscription_ids"
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

variable "resource_names" {
  type        = map(string)
  description = "Overrides for resource names|hidden"
}

variable "pipeline_files" {
  description = "The pipeline files to upload to the repository|hidden"
  type = map(object({
    file_path   = string
    target_path = string
  }))
}

variable "pipeline_template_files" {
  type = map(object({
    file_path   = string
    target_path = string
    environment_user_assigned_managed_identity_mappings = list(object({
      environment_key                    = string
      user_assigned_managed_identity_key = string
    }))
  }))
}
