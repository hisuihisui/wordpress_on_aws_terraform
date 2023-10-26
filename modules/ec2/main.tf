# EC2
resource "aws_instance" "wordpress" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  user_data     = file("${path.module}/scripts/user_data.sh")

  vpc_security_group_ids = [aws_security_group.wordpress_ec2.id]

  tags = {
    Name = "${var.prefix}-ec2-wordpress-${var.az}"
  }
}

resource "aws_security_group" "wordpress_ec2" {
  name        = "wordpress-ec2-sg"
  description = "with wordpress ec2"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-ec2-wordpress-sg"
  }
}

# EC2用EIP
resource "aws_eip" "ec2" {
  instance = aws_instance.wordpress.id
  domain   = "vpc"
  tags = {
    Name = "${var.prefix}-eip-ec2-${var.az}"
  }
}
