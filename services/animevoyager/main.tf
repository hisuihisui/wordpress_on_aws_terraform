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
  internet_gateway_id = aws_internet_gateway.public.id
  prefix              = local.prefix
  vpc_id              = aws_vpc.main.id
  # 他はデフォルト値でOK
}

module "subnet_1c" {
  source              = "../../modules/subnet"
  az                  = "ap-northeast-1c"
  internet_gateway_id = aws_internet_gateway.public.id
  prefix              = local.prefix
  private_subnet_cidr = "172.16.11.0/24"
  public_subnet_cidr  = "172.16.10.0/24"
  vpc_id              = aws_vpc.main.id
}


# EC2
module "ec2_1a" {
  source           = "../../modules/ec2"
  alb_sg_id        = module
  ami              = local.ami
  instance_type    = local.instance_type
  prefix           = local.prefix
  public_subnet_id = module.subnet_1a.public_subnet_id
  vpc_id           = aws_vpc.main.id
}

# ALB
module "alb" {
  source = "../../modules/elb"
  prefix = local.prefix
  subnets = [
    module.subnet_1a.public_subnet_id,
    module.subnet_1c.public_subnet_id
  ]
  vpc_id              = aws_vpc.main.id
  wordpress_ec2_id    = module.ec2_1a.instance_id
  wordpress_ec2_sg_id = module.ec2_1a.ec2_sg_id
}
