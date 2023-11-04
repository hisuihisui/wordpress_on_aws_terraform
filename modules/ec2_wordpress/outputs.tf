output "instance_id" {
  value = aws_instance.wordpress.id
}

output "ec2_sg_id" {
  value = aws_security_group.wordpress_ec2.id
}
