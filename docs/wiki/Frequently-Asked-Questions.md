<!-- markdownlint-disable first-line-h1 -->
## Azure landing zones Terraform accelerator FAQ

This article answers frequently asked questions relating to the Azure landing zones Terraform accelerator.

> If you have a question not listed here, please raise an [issue][github_issues] and we'll do our best to help.

This is a work in progress and will be completed over the next few months.

## Questions about customisation

### How do I use my own naming convention for the resources that are deployed?

Follow these steps to customise the resource names:

1. At step 2.2 of the quickstart, you will run the `New-ALZEnvironment` command to start the user input process.
1. Once the prompt appears for the first question open the relevant bootstrap `terraform.tfvars` file:
    1. Azure DevOps: `./v#.#.#/bootstrap/azuredevops/terraform.tfvars`
    1. GitHub: `./v#.#.#/bootstrap/github/terraform.tfvars`
1. Look for the variable called `resource_names`.
1. Update this map to have the names you desire and save it.
1. Continue with the user input as normal.

You'll now get the names you specified instead of the default ones.