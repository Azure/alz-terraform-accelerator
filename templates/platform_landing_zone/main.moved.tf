# Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm v0.18.1 manages Azure Bastion with azapi_resource instead of
# azurerm_bastion_host. The moved blocks migrate the hub keys used by the examples in place. The removed block makes
# Terraform forget, rather than destroy, a Bastion host under any other hub key; add a moved block for that key before
# upgrading. See "Upgrading Azure Bastion" in README.md.
# NOTE: These blocks support migration to the new module version and will be removed in the next major version.

moved {
  from = module.hub_and_spoke_vnet[0].module.bastion_host["primary"].azurerm_bastion_host.this
  to   = module.hub_and_spoke_vnet[0].module.bastion_host["primary"].azapi_resource.bastion[0]
}

moved {
  from = module.hub_and_spoke_vnet[0].module.bastion_host["secondary"].azurerm_bastion_host.this
  to   = module.hub_and_spoke_vnet[0].module.bastion_host["secondary"].azapi_resource.bastion[0]
}

removed {
  from = module.hub_and_spoke_vnet.module.bastion_host.azurerm_bastion_host.this

  lifecycle {
    destroy = false
  }
}
