variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|1|starter_module"
  type        = string
  default     = "basic"
}

variable "github_personal_access_token" {
  description = "Personal access token for GitHub|2"
  type        = string
  sensitive   = true
}

variable "github_organization_name" {
  description = "The name of your GitHub organization. This is the section of the url after 'github.com'. E.g. enter 'my-org' for 'https://github.com/my-org'|3"
  type        = string
}

variable "use_separate_repository_for_workflow_templates" {
  description = "Controls whether to use a separate repository to store action templates. This is an extra layer of security to ensure that the azure credentials can only be leveraged for the specified workload|4"
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

variable "use_self_hosted_runners" {
  description = "Controls whether to use self-hosted runners for the actions|10"
  type        = bool
  default     = true
}

variable "use_private_networking" {
  description = "Controls whether to use private networking for the runner to storage account communication|11"
  type        = bool
  default     = true
}

variable "allow_storage_access_from_my_ip" {
  description = "Allow access to the storage account from the current IP address. We recommend this is kept off for security|12"
  type        = bool
  default     = false
}

variable "apply_approvers" {
  description = "Apply stage approvers to the action / pipeline, must be a list of SPNs separate by a comma (e.g. abcdef@microsoft.com,ghijklm@microsoft.com)|13"
  type        = list(string)
  default     = []
}

variable "root_parent_management_group_display_name" {
  description = "The root parent management group display name. This default to 'Tenant Root Group' if not supplied|15"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|16"
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

variable "pipeline_files" {
  description = "The pipeline files to upload to the repository|hidden"
  type = map(object({
    file_path   = string
    target_path = string
  }))
}

variable "pipeline_template_files" {
  description = "The pipeline template files to upload to the repository|hidden"
  type = map(object({
    file_path   = string
    target_path = string
    environment_user_assigned_managed_identity_mappings = list(object({
      environment_key                    = string
      user_assigned_managed_identity_key = string
    }))
  }))
}

variable "resource_names" {
  type        = map(string)
  description = "Overrides for resource names|hidden"
}

variable "runner_container_image" {
  description = "The container image to use for GitHub Runners|hidden"
  type        = string
}

variable "runner_name_environment_variable" {
  description = "The runner name environment variable supplied to the container|hidden"
  type        = string
  default     = "GH_RUNNER_NAME"
}

variable "runner_group_environment_variable" {
  description = "The runner group environment variable supplied to the container|hidden"
  type        = string
  default     = "GH_RUNNER_GROUP"
}

variable "runner_organization_environment_variable" {
  description = "The runner url environment variable supplied to the container|hidden"
  type        = string
  default     = "GH_RUNNER_URL"
}

variable "runner_token_environment_variable" {
  description = "The runner token environment variable supplied to the container|hidden"
  type        = string
  default     = "GH_RUNNER_TOKEN"
}

variable "default_runner_group_name" {
  description = "The default runner group name for unlicenses orgs|hidden"
  type        = string
  default     = "Default"
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
