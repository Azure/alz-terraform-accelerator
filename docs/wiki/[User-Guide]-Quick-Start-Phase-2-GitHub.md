<!-- markdownlint-disable first-line-h1 -->
### 2.2.2 GitHub

1. In your PowerShell Core (pwsh) terminal type `Deploy-Accelerator -i "terraform" -b "alz_github"`.
1. The module will download the latest accelerator and then prompt you for inputs.
1. Fill out the following inputs:
    1. `starter`: This is the choice of [Starter Modules][wiki_starter_modules], which is the baseline configuration you want for your Azure landing zone, E.g. `basic` , `hubnetworking` or `complete`. This also determines the second set of inputs you'll be prompted for here.
    1. `github_personal_access_token`: Enter the GitHub PAT you generated in a previous step.
    1. `github_organization_name`: Enter the name of your GitHub organization. This is the section of the url after `github.com`. E.g. enter `my-org` for `https://github.com/my-org`.
    1. `use_separate_repository_for_workflow_templates`: Determine whether to create a separate repository to store pipeline templates as an extra layer of security. Set to `false` if you don't wish to secure you pipeline templates by using a separate repository. This will default to `true`.
    1. `bootstrap_location`: Enter the Azure region where you would like to deploy the storage account and identity for your continuous delivery pipeline. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`.
    1. `bootstrap_subscription_id`: Enter the id of the subscription in which you would like to deploy the storage account and identity for your continuous delivery pipeline. If left blank, the subscription you are connected to via `az login` will be used. In most cases this is the management subscription.
    1. `service_name`: This is used to build up the names of your Azure and GitHub resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this.
    1. `environment_name`: This is used to build up the names of your Azure and GitHub resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this.
    1. `postfix_number`: This is used to build up the names of your Azure and GitHub resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this.
    1. `use_self_hosted_agents`: This controls if you want to deploy self-hosted runners. This will default to `true`.
    1. `github_runners_personal_access_token`: Enter the GitHub PAT you generated in a previous step specifically for the self-hosted runners. This only applies if you have `use_self_hosted_agents` set to `true`. This defaults to `""`.
    1. `use_private_networking`: This controls whether private networking is deployed for your self-hosted runners and storage account. This only applies if you have `use_self_hosted_agents` set to `true`. This defaults to `true`.
    1. `use_runner_group`: This controls whether to use a Runner Group for self hosted agents. This only applies if `use_self_hosted_agents` is `true` and your GitHub Organization is part of a licensed GitHub Enterprise. This defaults to `true`.
    1. `allow_storage_access_from_my_ip`: This controls whether to allow access to the storage account from your IP address. This is only needed for trouble shooting. This only applies if you have `use_private_networking` set to `true`. This defaults to `false`.
    1. `apply_approvers`: This is a list of service principal names (SPN) of people you wish to be in the group that approves apply of the Azure landing zone module. This is a comma-separated list like `abc@xyz.com,def@xyz.com,ghi@xyz.com`. You may need to check what the SPN is prior to filling this out as it can vary based on identity provider.
1. You will now see a green message telling you that the next section is specific to the starter module you choose. Navigate to the documentation for the relevant starter module to get details of the specific inputs.
1. Once you have entered the starter module input, you see that a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then type `yes` and hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.

## Next Steps

Now head to [Phase 3][wiki_quick_start_phase_3].

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_starter_modules]:               %5BUser-Guide%5D-Starter-Modules "Wiki - Starter Modules"
[wiki_quick_start_phase_3]:           %5BUser-Guide%5D-Quick-Start-Phase-3 "Wiki - Quick Start - Phase 3"
