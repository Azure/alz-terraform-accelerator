variable "organization_name" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "repository_visibility" {
  type = string
}

variable "repository_files" {
  type = map(object({
    path = string
    flag = string
  }))
}

variable "environments" {
  type = map(string)
}

variable "managed_identity_client_ids" {
  type = map(string)
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "backend_azure_resource_group_name" {
  type = string
}

variable "backend_azure_storage_account_name" {
  type = string
}

variable "backend_azure_storage_account_container_name" {
  type = string
}

variable "approvers" {
  type = list(string)
}

variable "team_name" {
  type = string
}

variable "use_template_repository" {
  type = bool
}

variable "repository_name_templates" {
  type = string
}

variable "pipeline_templates" {
  type = map(object({
    target_path = string
    file_path   = string
    environment_user_assigned_managed_identity_mappings = list(object({
      environment_key                    = string
      user_assigned_managed_identity_key = string
    }))
  }))
}
