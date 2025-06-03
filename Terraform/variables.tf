variable "mercado_pago_client_id" {
  description = "Mercado Pago Client ID"
  type        = string
  default     = ""
  sensitive   = true
}

variable "mercado_pago_client_secret" {
  description = "Mercado Pago Client Secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "mercado_pago_client_credentials" {
  description = "Credenciais do cliente Mercado Pago"
  type        = string
  default     = ""
  sensitive   = true
}

variable "mercado_pago_access_token" {
  description = "Mercado Pago Access Token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_access_key_id" {
  type        = string
  description = "ID de chave de acesso da AWS"
  default     = ""
}

variable "aws_secret_access_key" {
  type        = string
  description = "chave de acesso da AWS"
  default     = ""
}

variable "aws_session_token" {
  type        = string
  description = "Token da sessão de acesso da AWS"
  default     = ""
}