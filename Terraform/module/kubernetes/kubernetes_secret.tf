resource "kubernetes_secret" "fastfoodapi_secrets" {
  metadata {
    name = var.secret_name
  }

  data = {
    postgres-connection-string      = var.postgres_connection_string
    mercado-pago-client-secret      = var.mercado_pago_client_secret
    mercado-pago-client-id          = var.mercado_pago_client_id
    mercado-pago-client-credentials = var.mercado_pago_client_credentials
    mercado-pago-access-token       = var.mercado_pago_access_token
  }
}