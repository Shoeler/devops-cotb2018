output "fqdn" {
  value = "${azurerm_kubernetes_cluster.k8scluster.fqdn}"
}

output "cube_config" {
  value = "${azurerm_kubernetes_cluster.k8scluster.kube_config}"
}

output "storage_account_key" {
  value = "${azurerm_storage_account.backend.primary_access_key}"
}

output "storage_account_name" {
  value = "${azurerm_storage_account.backend.name}"
}

