resource "kubernetes_deployment" "fastfoodapi_deployment" {
  metadata {
    name = var.deployment_name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.pod_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.pod_name
        }
      }

      spec {
        container {
          name              = "fastfoodapi-container"
          image             = "587167200064.dkr.ecr.us-east-1.amazonaws.com/fiap/fastfood:latest"
          image_pull_policy = "Always"

          port {
            container_port = var.container_port
          }

          resources {
            limits = {
              memory = var.memory_limit
              cpu    = var.cpu_limit
            }
            requests = {
              memory = var.memory_request
              cpu    = var.cpu_request
            }
          }
        }
      }
    }
  }
}
