resource "azurerm_resource_group" "k8s" {
  name     = "kubernetes-cotb"
  location = "${var.location}"
}

data "azurerm_resource_group" "k8s_MC" {
  name = "MC_${azurerm_resource_group.k8s.name}_${azurerm_kubernetes_cluster.k8scluster.name}_${var.location}"
}

resource "azurerm_storage_account" "backend" {
  name                     = "cotbstate"
  resource_group_name      = "${data.azurerm_resource_group.k8s_MC.name}"
  location                 = "${data.azurerm_resource_group.k8s_MC.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    environment = "cotb2018"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  resource_group_name   = "${data.azurerm_resource_group.k8s_MC.name}"
  storage_account_name  = "${azurerm_storage_account.backend.name}"
  container_access_type = "private"
}

resource "azurerm_public_ip" "app_ip" {
  name     = "cotb-app-pubip"
  location = "${var.location}"
  domain_name_label = "cotb-app"
  resource_group_name = "${data.azurerm_resource_group.k8s_MC.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "jenkins_ip" {
  name     = "cotb_pubip"
  location = "${var.location}"
  domain_name_label = "cotb-jenkins"
  resource_group_name = "${data.azurerm_resource_group.k8s_MC.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_container_registry" "cotbregistry" {
  name                = "cotbregistry"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  location            = "${azurerm_resource_group.k8s.location}"
  admin_enabled       = true
  sku                 = "Basic"

  tags {
    environment = "cotb2018"
  }
}

resource "azurerm_kubernetes_cluster" "k8scluster" {
  name                = "cotb_cluster"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  location            = "${var.location}"
  dns_prefix          = "cotb-2018"
  kubernetes_version  = "1.11.4"

  agent_pool_profile = {
    name            = "agents"
    count           = "1"
    vm_size         = "Standard_DS1"
    os_disk_size_gb = "30"
  }

  tags = {
    environment = "cotb2018"
  }

  linux_profile = {
    admin_username = "notanadmin"

    ssh_key = {
      key_data = "${var.key_data}"
    }
  }

  service_principal = {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}