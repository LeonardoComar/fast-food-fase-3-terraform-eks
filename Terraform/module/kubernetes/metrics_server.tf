resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.12.2"

  values = [
    <<-EOT
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: metrics-server-config
    data:
      metrics-server.conf: |
        --kubelet-insecure-tls
    EOT
  ]
}