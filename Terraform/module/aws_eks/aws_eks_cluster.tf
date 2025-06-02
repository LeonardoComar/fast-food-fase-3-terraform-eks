resource "aws_eks_cluster" "fastfood_cluster" {
  name     = var.eks_cluster_name
  role_arn = data.aws_iam_role.fastfood_role.arn
  version  = var.eks_cluster_version

  kubernetes_network_config {
    ip_family         = var.eks_kubernetes_network_ip_family
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks_cluster_name
  }
}