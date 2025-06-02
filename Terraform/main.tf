module "aws_eks" {
  source = "./module/aws_eks"

  vpc_id            = data.aws_vpc.fastfood_vpc.id
  subnet_ids        = local.subnet_todas_ids
  security_group_id = data.aws_security_group.fastfood_security_group_rds.id
}

module "kubernetes" {
  source = "./module/kubernetes"

  fastfood_cluster        = module.aws_eks.fastfood_cluster
  subnet_ids              = local.subnet_privadas_ids
  security_group_id       = data.aws_security_group.fastfood_security_group.id
  mysql_connection_string = data.aws_secretsmanager_secret_version.aws_secretsmanager_secret_version_fastfood.secret_string
}