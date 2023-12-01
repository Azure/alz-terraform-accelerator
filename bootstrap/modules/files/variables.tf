variable "starter_module_folder_path" {
  description = "Starter module folder path"
  type        = string
}

variable "pipeline_folder_path" {
  description = "Pipeline folder path"
  type        = string
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
