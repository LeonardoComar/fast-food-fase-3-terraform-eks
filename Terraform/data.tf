data "aws_eks_cluster_auth" "cluster" {
  name = module.aws_eks.fastfood_cluster.name
}

data "aws_vpc" "fastfood_vpc" {
  filter {
    name   = "tag:Name"
    values = ["fastfood-vpc"]
  }
}


data "aws_subnet" "private_1" {
  filter {
    name   = "tag:Name"
    values = ["fastfood-subnet-private-1"]
  }
}

data "aws_subnet" "private_2" {
  filter {
    name   = "tag:Name"
    values = ["fastfood-subnet-private-2"]
  }
}

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["fastfood-subnet-public-1"]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["fastfood-subnet-public-2"]
  }
}

locals {
  subnet_privates_ids = [
    data.aws_subnet.private_1.id,
    data.aws_subnet.private_2.id
  ]
}

locals {
  subnet_todas_ids = [
    data.aws_subnet.private_1.id,
    data.aws_subnet.private_2.id,
    data.aws_subnet.public_1.id,
    data.aws_subnet.public_2.id
  ]
}


data "aws_security_group" "fastfood_security_group" {
  filter {
    name   = "group-name"
    values = ["fastfood-security-group"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.fastfood_vpc.id]
  }
}

data "aws_security_group" "fastfood_security_group_rds" {
  filter {
    name   = "group-name"
    values = ["fastfood-security-group-rds"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.fastfood_vpc.id]
  }
}

data "aws_secretsmanager_secret" "aws_secretsmanager_secret_fastfood_4" {
  name = "aws-secretsmanager-secret-fastfood-4"
}

data "aws_secretsmanager_secret_version" "aws_secretsmanager_secret_version_fastfood_4" {
  secret_id = data.aws_secretsmanager_secret.aws_secretsmanager_secret_fastfood_4.id
}



