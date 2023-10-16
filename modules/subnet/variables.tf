# Subnetが属するAZ
variable "az" {
  default = "ap-northeast-1a"
}

# Prefix
variable "prefix" {
  type = string
}

# Public Subnet's Cidr
variable "private_route_table_id" {}

# Public Subnet's Cidr
variable "private_subnet_cidr" {
  default = "172.16.1.0/24"
}

# Public Subnet's Cidr
variable "public_route_table_id" {}

# Public Subnet's Cidr
variable "public_subnet_cidr" {
  default = "172.16.0.0/24"
}

# Subnetが属するVPCのID
variable "vpc_id" {}
