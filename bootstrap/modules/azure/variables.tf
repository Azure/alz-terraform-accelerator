variable "azure_location" {
  type = string
}

variable "user_assigned_managed_identity_name" {
  type = string
}

variable "create_federated_credential" {
  type    = bool
  default = true
}

variable "federated_credential_subjects" {
  type = map(string)
}

variable "federated_credential_issuer" {
  type = string
}

variable "federated_credential_name" {
  type = string
}

variable "create_agents_resource_group" {
  type    = bool
  default = false
}

variable "resource_group_identity_name" {
  type = string
}

variable "resource_group_agents_name" {
  type    = string
  default = ""
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
  type    = bool
  default = false
}

variable "agent_container_instances" {
  type = map(object({
    container_instance_name = string
    agent_name              = string
  }))
  default = {}
}

variable "agent_container_instance_image" {
  type    = string
  default = ""
}

variable "agent_pool_name" {
  type    = string
  default = ""
}

variable "agent_organization_url" {
  type    = string
  default = ""
}

variable "agent_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "target_subscriptions" {
  type = list(string)
}

variable "root_management_group_display_name" {
  description = "The root management group display name"
  type        = string
}