locals {
  prefix = "animevoyager-${var.env}"
}

variable "env" {
  type    = string
  default = "prod"
}
