# End to End Tests

## Overview

The end to end tests can be found in the ./github/workflows/end-to-end-test.yml action.

- The tests are triggered by `workflow_dispatch` or on `pull_request` only when the label `PR: Safe to test 🧪` has been added to the PR.
- The tests run against the environment `CSUTF`, which requires a manual approval to deploy.
- The tests run as a matrix, targeting different OS, VCS, Terraform and Auth Methods.

## Test Process

The test follow this process:

1. Check out the module from the PR merge branch.
1. Generate an `inputs.json` file that is used to override the prompts in the `ALZ` PowerShell module.
1. Install the `ALZ` PowerShell module.
1. Get the latest version tag for the live accelerator module.
1. Copy the `boostrap` and `template` folders into a folder named by the latest version tag.
1. Run the `New-New-ALZEnvironment` function to deploy the terraform.
1. Run a `terraform destroy` to clean up the environment.

## Environment

The tests use a set of environemnts to managed by the ALZ team. These are:

- Azure:
    - Tenant: CSU TF
    - Subscription: csu-tf-devops
    - User Assigned Managed Identity: alz-terraform-accelerator-cd-tests-identity (this has federated credentials)
- Azure DevOps
    - Organisation: microsoft-azure-landing-zones-cd-tests
- GiHub
    - Organisation: microsoft-azure-landingzones-cd-tests
