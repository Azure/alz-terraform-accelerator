<!-- markdownlint-disable first-line-h1 -->
Phase 3 of the accelerator is to run pipeline. Follow the steps below to do that.

## 3.1 Deploy the Landing Zone

Now you have created your bootstrapped environment you can deploy you Azure landing zone by triggering the continuous delivery pipeline in your version control system.

### 3.1.1 Azure DevOps

1. Navigate to [dev.azure.com](https://dev.azure.com) and sign in to your organization.
1. Navigate to your project.
1. Click `Pipelines` in the left navigation.
1. Click the `Azure Landing Zone Continuous Delivery` pipeline.
1. Click `Run pipeline` in the top right.
1. Take the defaults and click `Run`.
1. Your pipeline will run a `plan`.
1. If you provided `apply_approvers` to the bootstrap, it will prompt you to approve the `apply` stage.
1. Your pipeline will run an `apply` and deploy an Azure landing zone based on the starter module you choose.

### 3.1.2 GitHub

1. Navigate to [github.com](https://github.com).
1. Navigate to your repository.
1. Click `Actions` in the top navigation.
1. Click the `Azure Landing Zone Continuous Delivery` pipeline in the left navigation.
1. Click `Run workflow` in the top right, then keep the default branch and click `Run workflow`.
1. Your pipeline will run a `plan`.
1. If you provided `apply_approvers` to the bootstrap, it will prompt you to approve the `apply` job.
1. Your pipeline will run an `apply` and deploy an Azure landing zone based on the starter module you choose.

### 3.1.3 Local file system

1. Open a new PowerShell Core (pwsh) terminal or use the one you already have open.
1. Navigate to the directory shown in the `module_output_directory_path` output from the bootstrap.
1. If you choose to deploy the bootstrap resources in Azure, then you will need to navigate to the Azure Portal and find you storage account.
1. Make note of the `Resource Group Name`, `Storage account name`and `Container Name` from the storage account.
1. If you did not choose to deploy the bootstrap resources in Azure, type `terraform init` and hit enter.
1. If you choose to deploy the bootstrap resources in Azure, type `terraform init -backend-config="resource_group_name=<Resource Group Name>" -backend-config="storage_account_name=<Storage account name>" -backend-config="container_name=<Container Name>" -backend-config="key=terraform.tfstate"` , replacing the items in angle brackets and hit enter.
1. Type `terraform plan` and hit enter.
1. Review the plan.
1. If you are happy with the plan, then type `terraform apply` and hit enter.
1. The ALZ will now be deployed, this may take some time.
