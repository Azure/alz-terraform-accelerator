variable "folder_path" {
    description = "Template folder path"
    type        = string
}

variable "exclusions" {
    description = "List of files / partial file names to exclude"
    type        = list(string)
}