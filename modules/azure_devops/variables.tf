variable "access_token" {
  type      = string
  sensitive = true
}

variable "authentication_scheme" {
  type = string
  validation {
    condition     = can(regex("^(ManagedIdentity|WorkloadIdentityFederation)$", var.authentication_scheme))
    error_message = "authentication_scheme must be either ManagedIdentity or WorkloadIdentityFederation"
  }
}

variable "organization_url" {
    type = string
}

variable "create_project" {
  type    = bool
}

variable "project_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "service_connection_name" {
  type = string
}

variable "variable_group_name" {
  type = string
}

variable "managed_identity_client_id" {
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