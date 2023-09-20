# Developer Requirements

* [Terraform (Core)](https://www.terraform.io/downloads.html) - version 1.x or above
* [Go](https://golang.org/doc/install) version 1.20.x (to run the tests)

## On Windows

If you're on Windows you'll also need:

* [Git Bash for Windows](https://git-scm.com/download/win)
* [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)

For *GNU32 Make*, make sure its bin path is added to PATH environment variable.

For *Git Bash for Windows*, at the step of "Adjusting your PATH environment", please choose "Use Git and optional Unix tools from Windows Command Prompt".

Or, use [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/install)

### Setup on WSL with Ubuntu 22.04

#### Install Go and Make

1. Run `curl -L https://go.dev/dl/go1.21.0.linux-amd64.tar.gz -o go1.21.0.linux-amd64.tar.gz` (replace with a different version of go if desired)
2. Run `rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz`
3. Run `sudo nano ~/.profile`
4. Add the following lines at the end of the file:
```bash
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go/bin
export PATH=$PATH:$GOPATH/bin
```
5. Type <kbd>Ctrl</kbd> + <kbd>x</kbd> to save, then enter <kbd>y</kbd> and hit <kbd>enter</kbd>
5. Run `source ~/.profile`
6. Run `sudo apt-get update && apt-get install make`

#### Install Terraform

1. Follow these instructions `https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli`.

#### Setup Project Tools

1. Clone the repository
2. Navigate to the root of the repository
3. Run `make tools`

## PR Naming

We have adopted [conventional commit](https://www.conventionalcommits.org/) naming standards for PRs.

E.g.:

```text
feat(roleassignment)!: add `relative_scope` value.
^    ^              ^ ^
|    |              | |__ Subject
|    |_____ Scope   |____ Breaking change flag
|__________ Type
```

### Type

The following types are permitted:

* `chore` - Other changes that do not modify src or test files
* `ci` - changes to the CI system
* `docs` - documentation only changes
* `feat` - a new feature (this correlates with `MINOR` in Semantic Versioning)
* `fix` - a bug fix (this correlates with `PATCH` in Semantic Versioning)
* `refactor` - a code change that neither fixes a bug or adds a feature
* `revert` - revert to a previous commit
* `style` - changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
* `test` - adding or correcting tests

### Scope (Optional)

The following scopes are permitted:

* resourcegroup - pertaining to the resourcegroup sub-module
* roleassignment - pertaining to the roleassignment sub-module
* root - pertaining to the root module
* subscription - pertaining to the subscription sub-module
* usermanagedidentity - pertaining to the user-assigned managed identity sub-module
* virtualnetwork - pertaining to the virtual network sub-module

### Breaking Changes

An exclamation mark `!` is appended to the type/scope of a breaking change PR (this correlates with `MAJOR` in Semantic Versioning).
