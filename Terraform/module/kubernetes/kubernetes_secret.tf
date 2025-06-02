resource "kubernetes_secret" "fastfoodapi_secrets" {
  metadata {
    name = var.secret_name
  }
}