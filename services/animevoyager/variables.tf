locals {
  # Amazon Linux 2023 AMI
  ami = "ami-0d48337b7d3c86f62"
  instance_type = "t2.micro"
  prefix = "animevoyager-${var.env}"
}

# VPC
variable "cidr_block" {
  default = "172.16.0.0/16"
}

variable "env" {
  type    = string
  default = "prod"
}
