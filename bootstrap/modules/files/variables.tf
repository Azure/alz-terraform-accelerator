variable "starter_module_folder_path" {
  description = "Starter module folder path"
  type        = string
}

variable "pipeline_folder_path" {
  description = "Pipeline folder path"
  type        = string
  default     = ""
}

variable "pipeline_files" {
  description = "Pipeline files"
  type = map(object({
    file_path   = string
    target_path = string
  }))
  default = {}
}

variable "pipeline_template_files" {
  description = "Pipeline template files"
  type = map(object({
    file_path   = string
    target_path = string
  }))
  default = {}
}

variable "additional_files" {
  description = "Additional files"
  type        = list(string)
  default     = []
}

variable "configuration_file_path" {
  description = "Configuration file path"
  type        = string
  default     = ""
}

variable "built_in_configurartion_file_name" {
  description = "Built-in configuration file name"
  type        = string
  default     = "config.yaml"
}
