# VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block

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
module "network_1a" {
  source              = "../../modules/network"
  internet_gateway_id = aws_internet_gateway.public.id
  prefix              = local.prefix
  vpc_id              = aws_vpc.main.id
  # 他はデフォルト値でOK
}

module "network_1c" {
  source              = "../../modules/network"
  az                  = "ap-northeast-1c"
  internet_gateway_id = aws_internet_gateway.public.id
  prefix              = local.prefix
  public_subnet_cidr  = "172.16.10.0/24"
  vpc_id              = aws_vpc.main.id
}


# EC2
module "ec2_wordpress_1a" {
  source           = "../../modules/ec2_wordpress"
  alb_sg_id        = module.alb_external.alb_sg_id
  ami              = local.ami
  instance_type    = local.instance_type
  prefix           = local.prefix
  public_subnet_id = module.network_1a.public_subnet_id
  vpc_id           = aws_vpc.main.id
}

# ALB
module "alb_external" {
  source          = "../../modules/alb_external"
  certificate_arn = module.domain.certificate_arn
  prefix          = local.prefix
  subnets = [
    module.network_1a.public_subnet_id,
    module.network_1c.public_subnet_id
  ]
  vpc_id                = aws_vpc.main.id
  vpc_cidr_block        = local.vpc_cidr_block
  wordpress_ec2_id_list = [module.ec2_wordpress_1a.instance_id]
}

# Route53
module "domain" {
  source = "../../modules/domain"
  domain = local.domain
  alb_parameter = {
    dns_name = module.alb_external.alb_dns_name
    zone_id  = module.alb_external.alb_zone_id
  }
}
