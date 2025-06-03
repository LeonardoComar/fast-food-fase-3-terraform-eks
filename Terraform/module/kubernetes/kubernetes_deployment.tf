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
          image             = "ghcr.io/renaneustaquio/fastfoodapi:latest"
          image_pull_policy = "Always"

          port {
            container_port = var.container_port
          }

          env {
            name  = "ASPNETCORE_ENVIRONMENT"
            value = "Production"
          }

          env {
            name = "ConnectionStrings__DefaultConnection"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "postgres-connection-string"
              }
            }
          }

          env {
            name  = "MercadoPago__UrlBase"
            value = var.mercado_pago_url_base
          }

          env {
            name = "MercadoPago__ClientSecret"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "mercado-pago-client-secret"
              }
            }
          }

          env {
            name = "MercadoPago__ClientId"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "mercado-pago-client-id"
              }
            }
          }

          env {
            name = "MercadoPago__ClientCredentials"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "mercado-pago-client-credentials"
              }
            }
          }

          env {
            name  = "MercadoPago__UserId"
            value = var.mercado_pago_user_id
          }

          env {
            name  = "MercadoPago__PosId"
            value = var.mercado_pago_pos_id
          }

          env {
            name = "MercadoPago__AccessToken"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "mercado-pago-access-token"
              }
            }
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
