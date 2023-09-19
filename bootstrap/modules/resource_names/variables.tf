variable "azure_location" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "postfix_number" {
  type = number
}

variable "resource_names" {
  type = map(string)
}
