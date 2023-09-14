variable "test_variable_01" {
  type = string
  description = "This is the first test variable|1|azure_name"
}

variable "test_variable_02" {
  type = number
  description = "This is the second test variable|2|number"
}

variable "test_variable_03" {
  type = bool
  description = "This is the third test variable|3|bool"
}

variable "test_variable_04" {
  type = string
  description = "This is the fourth test variable|4|azure_location"
}

variable "test_variable_05" {
  type = string
  description = "This is the fifth test variable|5|guid"
}

variable "test_variable_06" {
  type = string
  description = "This is the sixth test variable.|6|azure_name"
  default = "testing-123"
}