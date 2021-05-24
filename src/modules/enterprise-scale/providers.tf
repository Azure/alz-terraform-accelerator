# The following providers are placeholders only
# and the pipeline will generate overrides to
# configure the required subscription_id values
# for each alias.

provider "azurerm" {
  alias = "core"
  features {}

}

provider "azurerm" {
  alias = "management"
  features {}

}