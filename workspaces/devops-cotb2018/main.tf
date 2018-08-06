resource "azurerm_resource_group" "k8s" {
  name     = "kubernetes-cotb"
  location = "${var.location}"
}

data "azurerm_resource_group" "k8s_MC" {
  name = "MC_${azurerm_resource_group.k8s.name}_${azurerm_kubernetes_cluster.k8scluster.name}_${var.location}"
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
  kubernetes_version  = "1.10.6"

  agent_pool_profile = {
    name            = "agents"
    count           = "2"
    vm_size         = "Standard_DS1"
    os_disk_size_gb = "30"
  }

  tags = {
    environment = "cotb2018"
  }

  linux_profile = {
    admin_username = "notanadmin"

    ssh_key = {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD+mpRUu10hjeczbAfaqzdNNmR70Kpgv+BumFobfIf2z70ld5JJtLqGK2Rs3bVY/5vKytrG/y00apUDL5PeH37ZAvaB0sYwfjX0vJl9cW1W0JsRk5y7uTWosc2qZi44bNv5xloexrFM8WEcw+A9KsHJ2NaCl3WLJofR9VtmrDPsVvQS8JrBv1DTJ7FbY8Cq4F1CVvsmu8IpwiHqgqihG2gzD6N7+KgNC4L3NfwgbWLjq3k9QdEk1J2Bp/aZd4/+Gu5GQ4IK2q1GFNd2xPAM/Zg8eePeyi/rqrDpV+2GoXnOiqt9qw6m0SjBgKm0CQRlPzTUpHBLthvO1pph+qVvAper schuylerbishop@Schuylers-MacBook-Pro.local"
    }
  }

  service_principal = {
    client_id     = "4a84d8b1-9775-4815-a043-47b79448c77b"
    client_secret = "91e6e13f-3948-43b7-beb3-67bb304a76ce"
  }
}