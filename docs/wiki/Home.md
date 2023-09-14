<!-- markdownlint-disable first-line-heading first-line-h1 -->
Welcome the Azure landing zones Terraform accelerator!

The [Azure landing zones Terraform module][alz_tf_registry] provides an opinionated approach for deploying and managing the core platform capabilities of [Azure landing zones architecture][alz_architecture] using Terraform, with a focus on the central resource hierarchy:

This accelerator provides an opinionated approach for configuring and securing that module in a continuous delivery pipeline. It has end to end automation for bootstrapping the module and it also provides guidance on branching strategies.

## Accelerator features

The accelerator bootstraps a continuous delivery environment for you. It supports both Azure DevOps and GitHub version control systems (VCS). It uses a PowerShell module to gather required user input, which in turn applies Terraform modules to configure the bootstrap environment.

The components of the environment are similar, but differ depending on your choice of VCS.

### GitHub

We only support federated credentials for GitHub as it is best practice.

- Azure:
  - Resource Group for State
  - Storage Account and Container for State
  - Resource Group for Identity
  - User Assigned Managed Identity (UAMI) with Federated Credentials
  - Permissions for the UAMI on state storage container, subscriptions and management groups

- GitHub
  - Repository
  - Starter Terraform module with tfvars
  - Branch policy
  - Action for Continuous Integration
  - Action for Continuous Delivery
  - Environment for Plan
  - Environment for Apply
  - Action Variables for Backend and Plan / Apply
  - Team and Members for Apply Approval

### Azure DevOps with Workload identity federation (WIF / OIDC)

This is the recommended authenticaton method for Azure DevOps.

- Azure:
  - Resource Group for State
  - Storage Account and Container for State
  - Resource Group for Identity
  - User Assigned Managed Identity (UAMI) with Federated Credentials
  - Permissions for the UAMI on state storage container, subscriptions and management groups

- Azure DevOps
  - Project (can be supplied or created)
  - Repository
  - Starter Terraform module with tfvars
  - Branch policy
  - Pipeline for Continuous Integration
  - Pipeline for Continuous Delivery
  - Environment for Plan
  - Environment for Apply
  - Variable Group for Backend
  - Service Connection with Workload identity federation for Plan / Apply
  - Group and Members for Apply Approval

### Azure DevOps with Managed identity and self-hosted agents

We include this option as Workload identity federation (WIF) is still in preview, but it will be removed once WIF is generally available to simplify the accelerator and promote best practice.

- Azure:
  - Resource Group for State
  - Storage Account and Container for State
  - Resource Group for Identity
  - User Assigned Managed Identity (UAMI)
  - Permissions for the UAMI on state storage container, subscriptions and management groups
  - 2 Container Instances with UAMI hosting Azure DevOps Agents

- Azure DevOps
  - Project (can be supplied or created)
  - Repository
  - Starter Terraform module with tfvars
  - Branch policy
  - Pipeline for Continuous Integration
  - Pipeline for Continuous Delivery
  - Environment for Plan
  - Environment for Apply
  - Variable Group for Backend
  - Service Connection with Managed identity for Plan / Apply
  - Group and Members for Apply Approval
  - Agent Pool

![Azure landing zone accelerator process][alz_accelerator_overview]

## Next steps

Check out the [User Guide](User-Guide).

## Terraform landing zones

The following diagram and links detail the Azure landing zone, but you can learn a lot more about the Azure landing zones enterprise scale module [here](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki).

![Azure landing zone conceptual architecture][alz_tf_overview]

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
