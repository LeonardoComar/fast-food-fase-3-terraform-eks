resource "kubernetes_service" "fastfoodapi_service" {
  metadata {
    name = var.service_name
    labels = {
      run = var.service_label
    }
  }

  spec {
    selector = {
      app = var.pod_name
    }

    port {
      name        = "http"
      port        = var.service_port
      target_port = var.container_port
      protocol    = "TCP"
    }

    type = var.service_type
  }
}
