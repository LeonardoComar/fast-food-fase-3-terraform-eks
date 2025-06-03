###### Variáveis para os Addons do EKS ######

variable "eks_addon_vpc_cni_version" {
  description = "Versão do addon VPC CNI para o EKS"
  type        = string
  default     = "v1.19.3-eksbuild.1"
}

variable "eks_addon_kube_proxy_version" {
  description = "Versão do addon Kube Proxy para o EKS"
  type        = string
  default     = "v1.32.0-eksbuild.2"
}

variable "eks_addon_coredns_version" {
  description = "Versão do addon CoreDNS para o EKS"
  type        = string
  default     = "v1.11.4-eksbuild.2"
}

variable "eks_addon_ebs_csi_driver_version" {
  description = "Versão do addon EBS CSI Driver para o EKS"
  type        = string
  default     = "v1.41.0-eksbuild.1"
}

###### Variáveis para o Cluster EKS ######

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "fastfood-cluster"
}

variable "eks_cluster_version" {
  description = "Versão do cluster EKS"
  type        = string
  default     = "1.32"
}

variable "eks_kubernetes_network_ip_family" {
  description = "Família de IP do cluster Kubernetes (IPv4 ou IPv6)"
  type        = string
  default     = "ipv4"
}

variable "eks_service_ipv4_cidr" {
  description = "CIDR para o serviço do Kubernetes"
  type        = string
  default     = "10.100.0.0/16"
}

###### Variáveis para o Node Group EKS ######

variable "eks_node_group_name" {
  description = "Nome do grupo de nós do EKS"
  type        = string
  default     = "fastfood-node-group"
}

variable "eks_node_group_desired_size" {
  description = "Número desejado de nós no grupo EKS"
  type        = number
  default     = 2
}

variable "eks_node_group_min_size" {
  description = "Número mínimo de nós no grupo EKS"
  type        = number
  default     = 1
}

variable "eks_node_group_max_size" {
  description = "Número máximo de nós no grupo EKS"
  type        = number
  default     = 3
}

variable "eks_instance_types" {
  description = "Tipos de instância para os nós do EKS"
  type        = list(string)
  default     = ["t3.small"]
}

variable "eks_ami_type" {
  description = "Tipo de AMI a ser utilizado nos nós do EKS"
  type        = string
  default     = "AL2_x86_64"
}

variable "eks_disk_size" {
  description = "Tamanho do disco em GB para os nós do EKS"
  type        = number
  default     = 20
}

variable "subnet_ids" {
  description = "IDs das subnets"
  type        = list(string)
}



variable "vpc_id" {
  description = "ID da vpc"
  type        = string
}

variable "security_group_id" {
  description = "ID do security group"
  type        = any
}