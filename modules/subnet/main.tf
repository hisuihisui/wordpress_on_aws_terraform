# Public Subnet
# ALBが使用
resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.az

  tags = {
    Name = "${var.prefix}-public_subnet-${var.az}"
  }
}


# ルートテーブルとサブネットを関連付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = var.public_route_table_id
}


# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az
  # パブリックIPアドレス不要なので、false
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.prefix}-private_Subnet_${var.az}"
  }
}

# ルートテーブルとプライベートサブネットを関連付け
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = var.private_route_table_id
}
