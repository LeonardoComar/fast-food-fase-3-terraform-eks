resource "aws_security_group_rule" "access_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = var.security_group_id
  source_security_group_id = aws_eks_cluster.fastfood_cluster.vpc_config[0].cluster_security_group_id
}