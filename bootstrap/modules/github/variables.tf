variable "organization_name" {
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

variable "repository_visibility" {
  type = string
}

variable "repository_files" {
  type = map(object({
    path = string
    flag = string
  }))
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
