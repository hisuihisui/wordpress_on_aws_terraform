# VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${local.prefix}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.prefix}-internet_gateway"
  }
}


# Subnet
module "subnet_1a" {
  source              = "../../modules/subnet"
  count_nat_gateway   = 1
  internet_gateway_id = aws_internet_gateway.public.id
  prefix              = local.prefix
  vpc_id              = aws_vpc.main.id
  # 他はデフォルト値でOK
}

module "subnet_1c" {
  source              = "../../modules/subnet"
  az                  = "ap-northeast-1c"
  count_nat_gateway   = 0
  internet_gateway_id = aws_internet_gateway.public.id
  prefix              = local.prefix
  private_subnet_cidr = "172.16.11.0/24"
  public_subnet_cidr  = "172.16.10.0/24"
  vpc_id              = aws_vpc.main.id
}
