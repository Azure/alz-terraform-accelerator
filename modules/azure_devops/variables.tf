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