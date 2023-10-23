variable "ami" { }

variable "az" {
  default = "ap-northeast-1a"
}

variable "instance_type" { }

variable "prefix" {
  type = string
}

variable "private_subnet_id" { }

variable "vpc_id" { }
