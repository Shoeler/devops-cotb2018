provider "azurerm" {
  version = "~> 1.9"
}

resource "azurerm_resource_group" "k8s" {
  name     = "kubernetes-cotb"
  location = "${var.location}"
}
