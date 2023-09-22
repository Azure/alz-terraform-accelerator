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
  description = "The organization for the version control system to use for the deployment|3"
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
  type        = string
  default     = "private"
}

variable "root_management_group_display_name" {
  description = "The root management group display name|10"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|11"
  type        = list(string)
  default     = []
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
}
