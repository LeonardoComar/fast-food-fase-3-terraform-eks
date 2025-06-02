resource "kubernetes_horizontal_pod_autoscaler_v2" "fastfoodapi_hpa" {
  depends_on = [helm_release.metrics_server]
  metadata {
    name      = "fastfoodapi-hpa"
    namespace = "default"
  }

  spec {
    min_replicas = 1
    max_replicas = 5

    scale_target_ref {
      kind = "Deployment"
      name = var.deployment_name
    }
    behavior {
      scale_down {
        stabilization_window_seconds = 300
        select_policy                = "Min"
        policy {
          period_seconds = 120
          type           = "Pods"
          value          = 1
        }

        policy {
          period_seconds = 310
          type           = "Percent"
          value          = 100
        }
      }
      scale_up {
        stabilization_window_seconds = 600
        select_policy                = "Max"
        policy {
          period_seconds = 180
          type           = "Percent"
          value          = 100
        }
        policy {
          period_seconds = 600
          type           = "Pods"
          value          = 5
        }
      }
    }
  }
}