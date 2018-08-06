provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8scluster.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "cotb-app" {
  metadata {
    annotations {
      name = "example-annotation"
    }

    labels {
      mylabel = "test"
    }

    name = "test"
  }
}