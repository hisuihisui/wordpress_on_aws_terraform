variable "ami" {}

variable "alb_sg_id" {}

variable "az" {
  default = "ap-northeast-1a"
}

variable "instance_profile_name" {}

variable "instance_type" {}

variable "prefix" {
  type = string
}

variable "public_subnet_id" {}

variable "vpc_id" {}
