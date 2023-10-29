variable "prefix" {
  type = string
}

# ALBをおくSubnet
variable "subnets" {
  type = list(string)
}

variable "vpc_id" {}

variable "vpc_cidr_block" {}

variable "wordpress_ec2_id_list" {
  type = list(string)
}
