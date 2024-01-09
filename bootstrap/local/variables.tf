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

variable "create_seed_resources_in_azure" {
  description = "Whether to create seed resources in Azure (e.g. resource group, storage account, identities, etc.)|3"
  type        = bool
  default     = true
}

variable "azure_location" {
  description = "Azure Deployment location for the landing zone management resources|4|azure_location"
  type        = string
  default     = ""
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

variable "root_management_group_display_name" {
  description = "The root management group display name|9"
  type        = string
  default     = "Tenant Root Group"
}

variable "additional_files" {
  description = "Additional files to upload to the repository. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml)|10"
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
