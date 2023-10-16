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

# Route Table
# Public Subnetが使用
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-public-route_table"
  }
}

# Route
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id     = aws_internet_gateway.public.id
  # 通信先
  # インターネットへの疎通許可
  destination_cidr_block = "0.0.0.0/0"
}

# Route Table
# Private Subnetが使用
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-private-route_table"
  }
}



# Subnet
module "subnet_1a" {
  source                 = "../subnet"
  prefix                 = var.prefix
  private_route_table_id = aws_route_table.private.id
  public_route_table_id  = aws_route_table.public.id
  vpc_id                 = aws_vpc.main.id
  # 他はデフォルト値でOK
}

module "subnet_1c" {
  source                 = "../subnet"
  az                     = "ap-northeast-1c"
  prefix                 = var.prefix
  private_route_table_id = aws_route_table.private.id
  private_subnet_cidr    = "172.16.11.0/24"
  public_route_table_id  = aws_route_table.public.id
  public_subnet_cidr     = "172.16.10.0/24"
  vpc_id                 = aws_vpc.main.id
}
