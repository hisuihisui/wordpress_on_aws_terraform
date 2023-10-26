variable "prefix" {
  type = string
}

# ALBをおくSubnet
variable "subnets" {
  type = list(string)
}

variable "vpc_id" {}

variable "wordpress_ec2_id" {}

variable "wordpress_ec2_sg_id" {}
