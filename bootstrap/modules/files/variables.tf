variable "folder_path" {
  description = "Template folder path"
  type        = string
}

variable "exclusions" {
  description = "List of files / partial file names to exclude"
  type        = list(string)
  default     = []
}

variable "flag" {
  description = "A flag to add to each file object"
  type = string
  default = ""
}