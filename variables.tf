variable "prefix" {
  type    = string
  default = "github-oidc-demo"
}

variable "version_control_system" {
  type    = string
  description = "Whether to target github or azuredevops"
  validation {
    condition     = can(regex("^(github|azuredevops)$", var.version_control_system))
    error_message = "version_control_system must be either github or azuredevops"
  }
  default = "github"
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "github_token" {
  type      = string
  sensitive = true
  default = "random_string"
}

variable "github_organisation_target" {
  type    = string
  default = "my_organisation"
}

variable "azure_devops_token" {
  type      = string
  sensitive = true
  default = "random_string"
}

variable "azure_devops_organisation_prefix" {
  type    = string
  default = "https://dev.azure.com"
}

variable "azure_devops_organisation_target" {
  type = string
  default = "random_string"
}

variable "azure_devops_project_target" {
  type = string
  default = "alz"
}