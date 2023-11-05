variable "log_bucket_arn" {
  type = string
}

variable "log_bucket_name" {
  type        = string
}

variable "role_name" {
  type = string
}

variable "ssm_document_name" {
  type        = string
  default     = "SSM-SessionManagerRunShell"
}
