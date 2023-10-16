# VPC
resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "${local.prefix}-vpc"
  }
}

# Subnet
module "subnet_1a" {
  source = "../../modules/subnet"
  prefix = local.prefix
  vpc_id = aws_vpc.main.id
  # 他はデフォルト値でOK
}

module "subnet_1c" {
  source              = "../../modules/subnet"
  az                  = "ap-northeast-1c"
  prefix              = local.prefix
  private_subnet_cidr = "172.16.11.0/24"
  public_subnet_cidr  = "172.16.10.0/24"
  vpc_id              = aws_vpc.main.id
}
