# Subnetが属するAZ
variable "az" {
  default = "ap-northeast-1a"
}

variable "internet_gateway_id" {}

# Prefix
variable "prefix" {
  type = string
}

# Public Subnet's Cidr
variable "public_subnet_cidr" {
  default = "172.16.0.0/24"
}

# Subnetが属するVPCのID
variable "vpc_id" {}
