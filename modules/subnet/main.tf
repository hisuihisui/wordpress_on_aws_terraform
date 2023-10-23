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

# Route Table
# Public Subnetが使用
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-public-route_table-${var.az}"
  }
}

# Route
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id     = var.internet_gateway_id
  # 通信先
  # インターネットへの疎通許可
  destination_cidr_block = "0.0.0.0/0"
}

# ルートテーブルとサブネットを関連付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
