# VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-internet_gateway"
  }
}


# Subnet
module "subnet_1a" {
  source              = "../subnet"
  internet_gateway_id = aws_internet_gateway.public.id
  is_nat_gateway      = 1
  prefix              = var.prefix
  vpc_id              = aws_vpc.main.id
  # 他はデフォルト値でOK
}

module "subnet_1c" {
  source              = "../subnet"
  az                  = "ap-northeast-1c"
  internet_gateway_id = aws_internet_gateway.public.id
  is_nat_gateway      = 0
  prefix              = var.prefix
  private_subnet_cidr = "172.16.11.0/24"
  public_subnet_cidr  = "172.16.10.0/24"
  vpc_id              = aws_vpc.main.id
}
