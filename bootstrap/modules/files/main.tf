locals {
  file_map = { for file in fileset(var.folder_path, var.include) : file => {
    path = "${var.folder_path}/${file}"
    flag = var.flag
    }
  }
}
