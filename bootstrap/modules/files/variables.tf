variable "folder_path" {
  description = "Template folder path"
  type        = string
}

variable "include" {
  description = "Files globs to match as per the fileset documentation: https://www.terraform.io/docs/language/functions/fileset.html"
  type        = string
  default     = "**"
}

variable "flag" {
  description = "A flag to add to each file object"
  type        = string
  default     = ""
}
