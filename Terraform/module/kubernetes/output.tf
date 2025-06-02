######### Output de Deployment #########

output "deployment_name" {
  value = kubernetes_deployment.fastfoodapi_deployment.metadata[0].name
}

######### Output de Secret #########

output "secret_name" {
  value = kubernetes_secret.fastfoodapi_secrets.metadata[0].name
}


######### Output de Service #########

output "service_name" {
  value = kubernetes_service.fastfoodapi_service.metadata[0].name
}

output "service_port" {
  value = kubernetes_service.fastfoodapi_service.spec[0].port[0].port
}