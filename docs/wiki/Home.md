<!-- markdownlint-disable first-line-heading first-line-h1 -->
Welcome the Azure landing zones Terraform accelerator!

The [Azure landing zones Terraform module][alz_tf_registry] provides an opinionated approach for deploying and managing the core platform capabilities of [Azure landing zones architecture][alz_architecture] using Terraform, with a focus on the central resource hierarchy:

This accelerator provides an opinionated approach for configuring and securing that module in a continuous delivery pipeline. It has end to end automation for bootstrapping the module and it also provides guidance on branching strategies.

![Azure landing zone accelerator process][alz_accelerator_overview]

![Azure landing zone conceptual architecture][alz_tf_overview]


## Next steps

Check out the [User Guide](User-Guide).

 [//]: # (*****************************)
 [//]: # (INSERT IMAGE REFERENCES BELOW)
 [//]: # (*****************************)

[alz_accelerator_overview]: media/alz-terraform-acclerator.png "A process flow shwing the areas covered by the Azure landing zones Terraform accelerator."

[alz_tf_overview]: media/alz-tf-module-overview.png "A conceptual architecture diagram highlighting the design areas covered by the Azure landing zones Terraform module."

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[alz_tf_registry]:  https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest "Terraform Registry: Azure landing zones Terraform module"
[alz_architecture]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture
[alz_hierarchy]:    https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org
[alz_management]:   https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management
[alz_connectivity]: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity
[alz_identity]:     https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access
