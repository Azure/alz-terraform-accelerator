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

## Questions about boostrap clean up

### I was just testing or I made a mistake, how do I remove the boostrap environment and start again?

After the Terraform apply has been complete there is an opportunity to remove the environment it just created. Follow these steps to run a `terraform destroy`.

1. Open a terminal and navigate to the relevant bootstrap folder:
    1. Azure DevOps: `cd ./v#.#.#/bootstrap/azuredevops`
    1. GitHub: `cd ./v#.#.#/bootstrap/github`
1. Run a this command `terraform destroy -var-file override.tfvars`.
1. Terraform will show a plan and prompt you to continue by typing `yes` and hitting enter.
1. Terraform will destroy all the resoources it created in the boostrap.

You'll not be able to delete the `./v#.#.#` folder and run the `New-ALZEnvironment` command again.

## Multiple landing zone deployments

### I want to deploy multiple landing zones, but the PowerShell command keeps trying to overrwrite my existing environment.

After bootstrapping, the PowerShell leaves the folder structure intact, including the Terraform state file. This is by design, so you have an opportunity to amend or destroy the environment. 

If you want to deploy to a separate environment, the simplest approach is to specify a separate folder for each deployment using thr `-Output` parameter. For example:

- Deployment 1: `New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Output "./deployment1"`
- Deployment 2: `New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Output "./deployment2"`

You can then deploy as many times as you like without interferring with a previous deployment.