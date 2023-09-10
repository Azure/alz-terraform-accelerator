variable "test_variable_01" {
  type = string
  description = "This is the first test variable"
}

variable "test_variable_02" {
  type = number
  description = "This is the second test variable"
}

# Example of converting to json: .\.tools\hcl2json_windows_amd64.exe .\templates\.test\variables.tf with  https://github.com/tmccombs/hcl2json/releases
