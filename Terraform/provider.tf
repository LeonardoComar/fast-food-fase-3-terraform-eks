terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = module.aws_eks.fastfood_cluster.endpoint
    cluster_ca_certificate = base64decode(module.aws_eks.fastfood_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = module.aws_eks.fastfood_cluster.endpoint
  cluster_ca_certificate = base64decode(module.aws_eks.fastfood_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}