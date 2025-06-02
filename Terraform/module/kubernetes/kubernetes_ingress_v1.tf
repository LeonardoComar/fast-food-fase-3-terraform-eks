resource "kubernetes_ingress_v1" "fastfoodapi_ingress" {
  metadata {
    name = "fastfoodapi-ingress"
    annotations = {
      "kubernetes.io/ingress.class"            = "alb"
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"  = "ip"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}]"
    }
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.fastfoodapi_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
