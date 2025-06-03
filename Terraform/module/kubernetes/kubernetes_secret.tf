resource "kubernetes_secret" "fastfoodapi_secrets" {
  metadata {
    name = var.secret_name
  }

  data = {
    postgres-connection-string      = var.postgres_connection_string
  }
}