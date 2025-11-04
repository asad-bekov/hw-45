resource "null_resource" "configure_kubectl" {
  depends_on = [yandex_kubernetes_cluster.netology-k8s]

  provisioner "local-exec" {
    command = <<EOT
      yc managed-kubernetes cluster get-credentials netology-k8s --external --force
    EOT
  }
}
