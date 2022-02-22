# Terraform ALZ implementation with CI/CD

## Updating the dependency lock file

Without access to the state file, you initialize Terraform without a backend in order to generate the dependency lock file.
You may then commit this to the repository like normal.

```bash
terrafom init -backend=false -upgrade
```
