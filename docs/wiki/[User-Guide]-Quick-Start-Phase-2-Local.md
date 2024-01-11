<!-- markdownlint-disable first-line-h1 -->
### 2.2.3 Local file system

1. In your PowerShell Core (pwsh) terminal type `New-ALZEnvironment -i "terraform" -c "local"`.
1. The module will download the latest accelerator and then prompt you for inputs.
1. Fill out the following inputs:
    1. `starter_module`: This is the choice of [Starter Modules][wiki_starter_modules], which is the baseline configuration you want for your Azure landing zone. This also determine the second set of input you'll be prompted for here.
    1. `target_directory`: This is the directory where the ALZ module code will be created. This defaults a directory called `local` in the root of the accelerator directory.
    1. `create_bootstrap_resources_in_azure`: This determines whether the bootstrap will create the resources in Azure (e.g storage account for state, identities, etc). This defaults to `true`.
    1. `bootstrap_location`: Enter the Azure region where you would like to deploy the storage account and identity for your continuous delivery pipeline. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`.
    1. `bootstrap_subscription_id`: Enter the id of the subscription in which you would like to deploy the storage account and identity for your continuous delivery pipeline. If left blank, the subscription you are connected to via `az login` will be used. In most cases this is the management subscription.
    1. `service_name`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this.
    1. `environment_name`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this.
    1. `postfix_number`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this.
    1. `root_management_group_display_name`: The is the name of the root management group that you applied permissions to in a previous step. This defaults to `Tenant Root Group`, but if you organization has changed it you'll need to enter the new display name.
    1. `additional_files`: This is a method to supply additional files to your starter module. This is specifically used when using the `complete` starter module to supply the `config.yaml` file. This must be specified as a comma-separated list of absolute file paths (e.g. c:\\config\\config.yaml or /home/user/config/config.yaml). If you don't supply an absolute path, it will fail.
1. You will now see a green message telling you that the next section is specific to the starter module you choose. Navigate to the documentation for the relevant starter module to get details of the specific inputs.
1. Once you have entered the starter module input, you see that a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then type `yes` and hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.
1. The Terraform run will output the path to the module files in an output called `module_output_directory_path`. Take a note of this path as you will need it in the next phase.

## Next Steps

Now head to [Phase 3][wiki_quick_start_phase_3].

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_starter_modules]:               %5BUser-Guide%5D-Starter-Modules "Wiki - Starter Modules"
[wiki_quick_start_phase_3]:           %5BUser-Guide%5D-Quick-Start-Phase-3 "Wiki - Quick Start - Phase 3"
