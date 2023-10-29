# ALB
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#application-load-balancer
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.wordpress_alb_sg.id]
  subnets         = var.subnets

  # 削除保護
  enable_deletion_protection = true

  tags = {
    Name = "${var.prefix}-alb"
  }
}

resource "aws_security_group" "wordpress_alb_sg" {
  name        = "wordpress_alb_sg"
  description = "with wordpress alb"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-wordpress-alb-sg"
  }
}

resource "aws_security_group_rule" "wordpress_alb_sg_ingress_http" {
  security_group_id = aws_security_group.wordpress_alb_sg.id
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "wordpress_alb_sg_egress" {
  security_group_id = aws_security_group.wordpress_alb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
}

# HTTPリスナー
resource "aws_lb_listener" "wordpress_alb_http" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

# ターゲットグループ
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name = "${var.prefix}-wordpress-alb-tg"
  }
}

resource "aws_lb_target_group_attachment" "wordpress_tg_attachment" {
  for_each = toset(var.wordpress_ec2_id_list)

  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = each.value
  port             = 80
}
