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

  ingress = {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    security_groups = [var.wordpress_ec2_sg_id]
  }

  tags = {
    Name = "${var.prefix}-wordpress-alb-sg"
  }
}

# HTTPリスナー
resource "aws_lb_listener" "wordpress_alb_http" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
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
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = var.wordpress_ec2_id
  port             = 80
}
