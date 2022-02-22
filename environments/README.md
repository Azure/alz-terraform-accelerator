# Environments

This directory provides some of the configuration for supporting different environments, for example, canary and prod.
The Terraform variable `environment` is fed into the settings module to provide a customized inputs to the ALZ Terraform module.

## Environment Configuration

Before running the workflows/pipeliens, you need to copy the template files into the `environments/{environmentName}` directory. You then must tailor the files to your specific needs.

Finally, the settings module is configured to provide customized outputs for `canary` and `prod` environments.
