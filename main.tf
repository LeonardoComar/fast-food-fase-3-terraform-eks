provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "cluster" {
  name = "fastfood"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "fastfood-app"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "fastfood-app"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "fastfood"
      }
    }

    template {
      metadata {
        labels = {
          app = "fastfood"
        }
      }

      spec {
        container {
          name  = "fastfood"
          image = "587167200064.dkr.ecr.us-east-1.amazonaws.com/fiap/fastfood:latest"

          env {
            name  = "DB_HOST"
            value = "my-rds-instance.chi8akyshzbu.us-east-1.rds.amazonaws.com"
          }

          env {
            name  = "DB_PORT"
            value = "3306"
          }

          env {
            name  = "DB_NAME"
            value = "db_fastfood"
          }

          env {
            name  = "DB_USER"
            value = "admin"
          }

          env {
            name  = "DB_PASSWORD"
            value = "Mudar123!"
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "fastfood-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "fastfood"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
