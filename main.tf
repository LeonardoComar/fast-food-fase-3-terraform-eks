terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

########################################
# Provider AWS (credenciais via Secrets)
########################################
provider "aws" {
  region = var.aws_region
}

########################################
# Remote state do projeto de RDS
########################################
data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = var.rds_state_bucket
    key    = var.rds_state_key
    region = var.aws_region
  }
}

########################################
# VPC e Subnets padrão
########################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

########################################
# ECR Repository
########################################
resource "aws_ecr_repository" "app_repo" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  # Política de ciclo de vida para manter apenas as 5 imagens mais recentes
  lifecycle_policy {
    policy = jsonencode({
      rules = [{
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }]
    })
  }
}

########################################
# EKS via module oficial
########################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.k8s_version

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  # Cria um node group gerenciado
  node_groups = {
    default = {
      desired_capacity                = 2
      instance_types                  = [var.node_instance_type]
      additional_security_group_ids   = [
        data.terraform_remote_state.rds.outputs.db_security_group_id
      ]
    }
  }
}

########################################
# Provider Kubernetes para deploy
########################################
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

########################################
# Deployment da aplicação no EKS
########################################
resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = var.app_name
          image = "${aws_ecr_repository.app_repo.repository_url}:${var.app_image_tag}"

          port {
            container_port = var.app_container_port
          }

          env {
            name  = "DB_HOST"
            value = data.terraform_remote_state.rds.outputs.db_endpoint
          }
          env {
            name  = "DB_NAME"
            value = data.terraform_remote_state.rds.outputs.db_name
          }
          env {
            name  = "DB_USER"
            value = data.terraform_remote_state.rds.outputs.db_username
          }
          env {
            name  = "DB_PASSWORD"
            value = data.terraform_remote_state.rds.outputs.db_password
          }
        }
      }
    }
  }
}

########################################
# Service para expor o Deployment
########################################
resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.app_name}-svc"
    namespace = var.app_namespace
  }

  spec {
    selector = {
      app = var.app_name
    }
    port {
      port        = var.app_service_port
      target_port = var.app_container_port
    }
    type = var.app_service_type
  }
}

########################################
# Outputs
########################################
output "ecr_repository_url" {
  description = "URL do repositório ECR"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_id
}

output "load_balancer_ip" {
  description = "Endereço do Load Balancer"
  value       = kubernetes_service.app.status.0.load_balancer.0.ingress.0.hostname
}

########################################
# Variáveis
########################################
variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "rds_state_bucket" {
  description = "Bucket S3 onde o estado do RDS está armazenado"
  type        = string
}

variable "rds_state_key" {
  description = "Caminho/Key do statefile do RDS"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "myapp-eks-cluster"
}

variable "k8s_version" {
  description = "Versão do Kubernetes para o EKS"
  type        = string
  default     = "1.24"
}

variable "node_instance_type" {
  description = "Tipo de instância para os nodes"
  type        = string
  default     = "t3.medium"
}

variable "app_name" {
  description = "Nome da aplicação no Kubernetes"
  type        = string
  default     = "myapp"
}

variable "app_namespace" {
  description = "Namespace onde a app será implantada"
  type        = string
  default     = "default"
}

variable "app_replicas" {
  description = "Número de réplicas da aplicação"
  type        = number
  default     = 2
}

variable "dockerhub_repo" {
  description = "Repositório Docker Hub (ex.: leocomar/myapp)"
  type        = string
  default     = "leocomar/myapp"
}

variable "app_image_tag" {
  description = "Tag da imagem Docker"
  type        = string
  default     = "latest"
}

variable "app_container_port" {
  description = "Porta exposta pelo container"
  type        = number
  default     = 8080
}

variable "app_service_port" {
  description = "Porta do Service Kubernetes"
  type        = number
  default     = 80
}

variable "app_service_type" {
  description = "Tipo de Service (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "ecr_repository_name" {
  description = "Nome do repositório ECR"
  type        = string
  default     = "myapp-ecr-repo"
}
