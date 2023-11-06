# # VPC
# resource "aws_vpc" "main" {
#   cidr_block = local.vpc_cidr_block

#   tags = {
#     Name = "${local.prefix}-vpc"
#   }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "public" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "${local.prefix}-internet_gateway"
#   }
# }


# # Subnet
# module "subnet_1a" {
#   source              = "../../modules/subnet"
#   internet_gateway_id = aws_internet_gateway.public.id
#   prefix              = local.prefix
#   vpc_id              = aws_vpc.main.id
#   # 他はデフォルト値でOK
# }

# module "subnet_1c" {
#   source              = "../../modules/subnet"
#   az                  = "ap-northeast-1c"
#   internet_gateway_id = aws_internet_gateway.public.id
#   prefix              = local.prefix
#   public_subnet_cidr  = "172.16.10.0/24"
#   vpc_id              = aws_vpc.main.id
# }

# # IAMロール
# module "role" {
#   source = "../../modules/role"
# }

# # EC2
# module "ec2_1a" {
#   source                = "../../modules/ec2"
#   alb_sg_id             = module.alb.alb_sg_id
#   ami                   = local.ami
#   instance_profile_name = module.role.wordpress_instance_profile_name
#   instance_type         = local.instance_type
#   prefix                = local.prefix
#   public_subnet_id      = module.subnet_1a.public_subnet_id
#   vpc_id                = aws_vpc.main.id
# }

# # Session Manager
# module "session_manager" {
#   source            = "../../modules/session_manager"
#   log_bucket_arn    = module.log_bucket.bucket_arn
#   log_bucket_name   = "${local.prefix}-log-bucket"
#   role_name         = module.role.wordpress_ec2_role_name
#   ssm_document_name = "${local.prefix}-SessionManagerRunShell"
# }

# # ログ保管用S3バケット
# module "log_bucket" {
#   source      = "../../modules/log_s3"
#   bucket_name = "${local.prefix}-log-bucket"
# }

# # ALB
# module "alb" {
#   source          = "../../modules/alb"
#   certificate_arn = module.route53.certificate_arn
#   prefix          = local.prefix
#   subnets = [
#     module.subnet_1a.public_subnet_id,
#     module.subnet_1c.public_subnet_id
#   ]
#   vpc_id                = aws_vpc.main.id
#   vpc_cidr_block        = local.vpc_cidr_block
#   wordpress_ec2_id_list = [module.ec2_1a.instance_id]
# }

# # Route53
# module "route53" {
#   source = "../../modules/route53"
#   domain = local.domain
#   alb_parameter = {
#     dns_name = module.alb.alb_dns_name
#     zone_id  = module.alb.alb_zone_id
#   }
# }
