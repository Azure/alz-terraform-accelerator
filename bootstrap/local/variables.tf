variable "starter_module" {
  description = "The starter module to use for the deployment. (e.g. 'basic')|1|starter_module"
  type        = string
  default     = "basic"
}

variable "target_directory" {
  description = "The target directory to create the landing zone files in. (e.g. 'c:\\landingzones\\my_landing_zone')|2"
  type        = string
  default     = ""
}

variable "create_bootstrap_resources_in_azure" {
  description = "Whether to create resources in Azure (e.g. resource group, storage account, identities, etc.)|3"
  type        = bool
  default     = true
}

variable "bootstrap_location" {
  description = "Azure Deployment location for the bootstrap resources (e.g. storage account, identities, etc)|4|azure_location"
  type        = string
  default     = ""
}

variable "bootstrap_subscription_id" {
  description = "Azure Subscription ID for the bootstrap resources (e.g. storage account, identities, etc). Leave empty to use the az login subscription|6|azure_subscription_id"
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

variable "root_parent_management_group_display_name" {
  description = "The root parent management group display name. This will default to 'Tenant Root Group' if not supplied|9"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|hidden"
  type        = list(string)
  default     = []
}

variable "target_subscriptions" {
  description = "The target subscriptions to apply onwer permissions to|hidden_azure_subscription_ids"
  type        = list(string)
}

variable "configuration_file_path" {
  description = "The name of the configuration file to be generated|hidden_configuration_file_path"
  type        = string
  default     = ""
}

variable "built_in_configurartion_file_name" {
  description = "The name of the built-in configuration file|hidden"
  type        = string
  default     = "config.yaml"
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

variable "resource_names" {
  type        = map(string)
  description = "Overrides for resource names|hidden"
}

variable "federated_credentials" {
  description = "Federated credentials for other version control systems|hidden"
  type = map(object({
    user_assigned_managed_identity_key = string
    federated_credential_subject       = string
    federated_credential_issuer        = string
    federated_credential_name          = string
  }))
  default = {}
}

variable "default_target_directory" {
  description = "The default target directory to create the landing zone files in|hidden"
  type        = string
  default     = "../../../local"
}
