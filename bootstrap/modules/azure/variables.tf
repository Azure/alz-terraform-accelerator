variable "azure_location" {
  type = string
}

variable "user_assigned_managed_identity_name" {
  type = string
}

variable "create_federated_credential" {
  type = bool
}

variable "federated_credential_subject" {
  type = string
}

variable "federated_credential_issuer" {
  type = string
}

variable "federated_credential_name" {
  type = string
}

variable "create_agents_resource_group" {
  type = bool
}

variable "resource_group_identity_name" {
  type = string
}

variable "resource_group_agents_name" {
  type = string
}

variable "resource_group_state_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "create_agents" {
  type = bool
}

variable "agent_container_instances" {
  type = map(object({
    container_instance_name = string
    agent_name              = string
  }))
}

variable "agent_container_instance_image" {
  type = string
}

variable "agent_pool_name" {
  type = string
}

variable "agent_organization_url" {
  type = string
}

variable "agent_token" {
  type      = string
  sensitive = true
}