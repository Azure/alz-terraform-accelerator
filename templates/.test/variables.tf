variable "test_variable_01" {
  type = string
  description = "This is the first test variable|azure_name"
}

variable "test_variable_02" {
  type = number
  description = "This is the second test variable"
}

variable "test_variable_03" {
  type = bool
  description = "This is the second test variable|bool"
}

variable "test_variable_04" {
  type = string
  description = "This is the second test variable|azure_location"
}

variable "test_variable_05" {
  type = string
  description = "This is the second test variable|guid"
}

variable "test_variable_06" {
  type = string
  description = "Default|azure_name"
  default = "testing-123"
}