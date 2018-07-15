output "fqdn" {
  value = "${azurerm_kubernetes_cluster.k8scluster.fqdn}"
}

output "cube_config" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config}"
}
