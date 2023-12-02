resource "terraform_data" "dev_labs_extension" {
  triggers_replace = [var.organization_name]

  input = {
    pat_token         = var.version_control_system_access_token
    organization_name = var.organization_name
  }

  provisioner "local-exec" {
    command     = "${path.module}/extension-install.ps1 -patToken \"${self.input.pat_token}\" -organizationName \"${self.input.organization_name}\""
    interpreter = ["pwsh", "-Command"]
  }
}
