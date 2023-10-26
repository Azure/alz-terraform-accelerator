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

variable "environment_name_plan" {
  type = string
}

variable "environment_name_apply" {
  type = string
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

variable "pipeline_ci_file" {
  type = string
}

variable "pipeline_cd_file" {
  type = string
}

variable "service_connection_plan_name" {
  type = string
}

variable "service_connection_apply_name" {
  type = string
}

variable "variable_group_name" {
  type = string
}

variable "agent_pool_name" {
  type = string
}

variable "managed_identity_plan_client_id" {
  type = string
}

variable "managed_identity_apply_client_id" {
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
