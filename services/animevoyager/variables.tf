locals {
  # Amazon Linux 2023 AMI
  ami           = "ami-0d48337b7d3c86f62"
  instance_type = "t2.micro"
  prefix        = "animevoyager-${var.env}"
}

variable "env" {
  type    = string
  default = "prod"
}
