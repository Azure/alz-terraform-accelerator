locals {
    files = fileset(var.folder_path, "**")
    filtered_files = sort(flatten([
        for f in local.files : [ 
            for e in var.exclusions : 
                strcontains(f, e) ? [] : [f]
        ]
    ]))
}