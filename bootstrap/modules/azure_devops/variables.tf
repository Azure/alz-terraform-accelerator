variable "authentication_scheme" {
  type = string
  validation {
    condition     = can(regex("^(ManagedServiceIdentity|WorkloadIdentityFederation)$", var.authentication_scheme))
    error_message = "authentication_scheme must be either ManagedServiceIdentity or WorkloadIdentityFederation"
  }
}

variable "use_legacy_organization_url" {
  type = bool
}

variable "organization_name" {
  type = string
}

variable "create_project" {
  type = bool
}

variable "project_name" {
  type = string
}

variable "environments" {
  type = map(object({
    environment_name        = string
    service_connection_name = string
    agent_pool_name         = string
  }))
}

variable "managed_identity_client_ids" {
  type = map(string)
}

variable "repository_name" {
  type = string
}

variable "repository_files" {
  type = map(object({
    path = string
    flag = string
  }))
}

variable "pipelines" {
  description = "The pipelines to create|hidden"
  type = map(object({
    pipeline_name           = string
    file_path               = string
    target_path             = string
    environment_keys        = list(string)
    service_connection_keys = list(string)
    agent_pool_keys         = list(string)
  }))
}

variable "variable_group_name" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "azure_subscription_name" {
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

variable "group_name" {
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
  }))
}
