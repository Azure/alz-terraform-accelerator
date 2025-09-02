# Azure Landing Zones Accelerator Starter Module for Terraform - Empty

This module is part of the Azure Landing Zones Accelerator solution.

This configuration includes a (relatively) minimal set of files to get you started, including a custom library.

The config will install the providers and includes the GitHub Actions workflow, and also includes a customer library (./lib) for the main avm-ptn-alz module.

## Cloning

If you have use the default values in the inputs.yml (`service_name: "alz"` and `environment_name: "mgmt"`) then your repository will be `https://github.com/my_org_name/alz-mgmt`.

Example git clone command.

```shell
git clone https://github.com/my_org_name/alz-mgmt.git
```

Open in Visual Studio Code.

```shell
code alz-mgmt
```

## Azure Verified Modules

Reference the [Azure Landing Zone AVM modules](https://registry.terraform.io/search/modules?q=Azure%2Favm-ptn-alz) to create your own configuration.

Each module has a drop down of examples to use as a starting point. For example, the [management example](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest/examples/management) for the core Azure Landing Zone pattern module.

## Example configuration

An example configuration has been included in the [./examples/management-only](./examples/management-only) folder. Feel free to copy the files into the root and modify to suit your needs.

Example terraform.tfvars

```ruby
subscription_id_connectivity = "subscription_guid"
subscription_id_identity     = "subscription_guid"
subscription_id_management   = "subscription_guid"
starter_locations            = ["region_name"]
email_security_contact       = "email_address"

tags = {
  "deployed_by" : "terraform",
  "source" : "Azure Landing Zones Accelerator"
}

```
