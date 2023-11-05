output "wordpress_instance_profile_name" {
  value = aws_iam_instance_profile.wordpress_ec2.name
}

output "wordpress_ec2_role_name" {
  value = aws_iam_role.wordpress_ec2_role.name
}
