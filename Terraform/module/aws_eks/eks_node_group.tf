resource "aws_eks_node_group" "fastfood_node_group" {
  cluster_name    = aws_eks_cluster.fastfood_cluster.name
  node_role_arn   = data.aws_iam_role.fastfood_role.arn
  node_group_name = var.eks_node_group_name
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.eks_node_group_desired_size
    min_size     = var.eks_node_group_min_size
    max_size     = var.eks_node_group_max_size
  }

  instance_types = var.eks_instance_types
  ami_type       = var.eks_ami_type
  disk_size      = var.eks_disk_size
  version        = var.eks_cluster_version

  depends_on = [aws_eks_cluster.fastfood_cluster]
}