variable "default_location" {
  description = "value of the default location"
  type        = string
}

variable "subscription_id_connectivity" {
  description = "value of the subscription id for the Connectivity subscription"
  type        = string
}

variable "subscription_id_identity" {
  description = "value of the subscription id for the Identity subscription"
  type        = string
}

variable "subscription_id_management" {
  description = "value of the subscription id for the Management subscription"
  type        = string
}

variable "root_id" {
  description = "value of the root id"
  type        = string
  default     = "es"
}

variable "root_name" {
  description = "value of the root name"
  type        = string
  default     = "Enterprise-Scale"
}
