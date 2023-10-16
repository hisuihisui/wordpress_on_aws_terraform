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

# Internet Gateway
resource "aws_internet_gateway" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-internet_gateway-${var.az}"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-public-route_table-${var.az}"
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

# ルートテーブルとサブネットを関連付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
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

# Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-private-route_table-${var.az}"
  }
}

# ルートテーブルとプライベートサブネットを関連付け
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
