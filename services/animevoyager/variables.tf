locals {
  # Amazon Linux 2023 AMI
  ami            = "ami-0d48337b7d3c86f62"
  domain         = "animevoyager.blog"
  instance_type  = "t2.micro"
  prefix         = "animevoyager-${var.env}"
  vpc_cidr_block = "172.16.0.0/16"
}

variable "env" {
  type    = string
  default = "prod"
}
