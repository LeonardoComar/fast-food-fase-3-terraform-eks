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