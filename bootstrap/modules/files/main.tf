locals {
  files = fileset(var.folder_path, "**")
  filtered_files = length(var.exclusions) == 0 ? sort(local.files) : sort(flatten([
    for f in local.files : [
      for e in var.exclusions :
      strcontains(f, e) ? [] : [f]
    ]
  ]))
  file_map = { for file in local.filtered_files : file => {
    path = "${var.folder_path}/${file}"
    flag = var.flag
    }
  }
}