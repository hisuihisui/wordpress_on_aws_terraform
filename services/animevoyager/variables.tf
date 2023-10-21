locals {
  prefix = "animevoyager-${var.env}"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "cidr_block" {
  default = "172.16.0.0/16"
}
