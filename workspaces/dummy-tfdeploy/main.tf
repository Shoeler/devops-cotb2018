resource "azurerm_resource_group" "dummy" {
  name     = "dummy-resourcegroup"
  location = "eastus"
}

resource "azurerm_storage_account" "sample" {
  name                     = "cotb-samplestorage"
  resource_group_name      = "${azurerm_resource_group.dummy.name}"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
