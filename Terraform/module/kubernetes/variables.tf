######### Variáveis de Deployment #########
variable "deployment_name" {
  type    = string
  default = "fastfoodapi-deployment"
}

variable "pod_name" {
  type    = string
  default = "fastfoodapi-pod"
}

variable "container_name" {
  type    = string
  default = "fastfoodapi-container"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "image" {
  type    = string
  default = "587167200064.dkr.ecr.us-east-1.amazonaws.com/fiap/fastfood:latest"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "cpu_limit" {
  type    = string
  default = "500m"
}

variable "cpu_request" {
  type    = string
  default = "250m"
}

variable "memory_limit" {
  type    = string
  default = "512Mi"
}

variable "memory_request" {
  type    = string
  default = "256Mi"
}

######### Variáveis Secrets #########
variable "secret_name" {
  type    = string
  default = "fastfoodapi-secrets"
}

variable "github_registry_name" {
  type    = string
  default = "github-registry-secret"
}

variable "mysql_connection_string" {
  type        = string
  default     = ""
  description = "Connection string for MySQL"
}

######### Cluster #########
variable "fastfood_cluster" {
  type = any
}

######### Kubernetes Service#########
variable "service_name" {
  type    = string
  default = "fastfoodapi-service"
}

variable "service_label" {
  type    = string
  default = "fastfoodapi-service"
}

variable "service_port" {
  type    = number
  default = 80
}

variable "service_type" {
  type    = string
  default = "LoadBalancer"
}

variable "subnet_ids" {
  description = "IDs das subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID do security group"
  type        = any
}