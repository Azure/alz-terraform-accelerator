// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
/*
SUMMARY : Local variables for the azapi exemption resources
AUTHOR/S: Cloud for Industry
*/
locals {
  retry = {
    error_message_regex = ["AuthorizationFailed"]
  }

  timeouts = {
    create = "30m"
    delete = "30m"
    update = "30m"
    read   = "30m"
  }
}
