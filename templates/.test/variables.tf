variable "test_variable_01" {
  type = string
  description = "This is the first test variable|4|azure_name"
}

variable "test_variable_02" {
  type = number
  description = "This is the second test variable|5|number"
}

variable "test_variable_03" {
  type = bool
  description = "This is the third test variable|6|bool"
}

variable "test_variable_04" {
  type = string
  description = "This is the fourth test variable|7|azure_location"
}

variable "test_variable_05" {
  type = string
  description = "This is the fifth test variable|8|guid"
}

variable "test_variable_06" {
  type = string
  description = "This is the sixth test variable.|9|azure_name"
  default = "testing-123"
}

variable "subscription_id_connectivity" {
  description = "The identifier of the Connectivity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|1|azure_subscription_id"
  type        = string
}

variable "subscription_id_identity" {
  description = "The identifier of the Identity Subscription. (e.g '00000000-0000-0000-0000-000000000000')|2|azure_subscription_id"
  type        = string
}

variable "subscription_id_management" {
  description = "The identifier of the Management Subscription. (e.g 00000000-0000-0000-0000-000000000000)|3|azure_subscription_id"
  type        = string
}