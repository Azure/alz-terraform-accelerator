variable "azure_location" {
  type    = string
}

variable "user_assigned_managed_identity_name" {
  type    = string
}

variable "create_federated_credential" {
    type    = bool
}

variable "federated_credential_subject" {
    type    = string
}

variable "federated_credential_issuer" {
    type    = string
}

variable "federated_credential_name" {
    type    = string
}

variable "create_agents_resource_group" {
    type    = bool
}

variable "resource_group_identity_name" {
    type    = string
}

variable "resource_group_agents_name" {
    type    = string
}

variable "resource_group_state_name" {
    type    = string
}

variable "storage_account_name" {
    type    = string
}

variable "storage_container_name" {
    type    = string
}