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


# Private Subnet
# resource "aws_subnet" "private" {
#   vpc_id            = var.vpc_id
#   cidr_block        = var.private_subnet_cidr
#   availability_zone = var.az
#   # パブリックIPアドレス不要なので、false
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.prefix}-private_subnet-${var.az}"
#   }
# }

# Route Table
# Private Subnetが使用
# resource "aws_route_table" "private" {
#   vpc_id = var.vpc_id

#   tags = {
#     Name = "${var.prefix}-private-route_table-${var.az}"
#   }
# }

# # ルートテーブルとプライベートサブネットを関連付け
# resource "aws_route_table_association" "private" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.private.id
# }

# Route
# プライベートサブネット → NATゲートウェイへの通信を許可
# resource "aws_route" "private" {
#   # リソースを作成するか
#   # 0：作成しない、1：作成する
#   count                  = var.count_nat_gateway
#   route_table_id         = aws_route_table.private.id
#   nat_gateway_id         = aws_nat_gateway.main[0].id
#   destination_cidr_block = "0.0.0.0/0"
# }

# EC2用EIP
resource "aws_eip" "ec2" {
  count  = var.count_ec2
  domain = "vpc"
  tags = {
    Name = "${var.prefix}-eip-ec2-${var.az}"
  }
}

# # NATゲートウェイ
# resource "aws_nat_gateway" "main" {
#   count = var.count_nat_gateway
#   # EIPの指定
#   allocation_id = aws_eip.nat_gateway[0].id
#   # サブネット
#   # パブリックサブネットを指定すること
#   subnet_id = aws_subnet.public.id
#   tags = {
#     Name = "${var.prefix}-nat_gateway-${var.az}"
#   }
# }
