variable "module_folder_path_relative" {
  description = "Whether the module folder path is relative to the module root"
  type        = bool
  default     = true
}

variable "module_folder_path" {
  description = "Module folder path"
  type        = string
}

variable "pipeline_folder_path_relative" {
  description = "Whether the pipeline folder path is relative to the module root"
  type        = bool
  default     = true
}

variable "pipeline_folder_path" {
  description = "Pipeline folder path"
  type        = string
}

variable "starter_module" {
  description = "Starter module name"
  type        = string
}

variable "pipeline_files" {
  description = "Pipeline files"
  type        = map(object({
    file_path   = string
    target_path = string
  }))
  default     = {}
}

variable "pipeline_template_files" {
  description = "Pipeline template files"
  type        = map(object({
    file_path   = string
    target_path = string
  }))
  default     = {}
}

variable "additional_files" {
  description = "Additional files"
  type        = list(string)
  default     = []
}
