resource "aws_eks_addon" "fastfood_vpc_cni" {
  cluster_name                = aws_eks_cluster.fastfood_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.eks_addon_vpc_cni_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.fastfood_node_group]
}

resource "aws_eks_addon" "fastfood_kube_proxy" {
  cluster_name                = aws_eks_cluster.fastfood_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.eks_addon_kube_proxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_addon.fastfood_vpc_cni]
}

resource "aws_eks_addon" "fastfood_core_dns" {
  cluster_name                = aws_eks_cluster.fastfood_cluster.name
  addon_name                  = "coredns"
  addon_version               = var.eks_addon_coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_addon.fastfood_kube_proxy]
}

resource "aws_eks_addon" "fastfood_ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.fastfood_cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.eks_addon_ebs_csi_driver_version
  resolve_conflicts_on_create = "NONE"
  resolve_conflicts_on_update = "NONE"

  depends_on = [aws_eks_addon.fastfood_core_dns]
}
