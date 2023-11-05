# EC2が使用するIAMロール
resource "aws_iam_role" "wordpress_ec2_role" {
  name               = "wordpress_ec2_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# 信頼ポリシー
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# インスタンスプロファイル
resource "aws_iam_instance_profile" "wordpress_ec2" {
  name = "wordpress_instance_profile"
  role = aws_iam_role.wordpress_ec2_role.name
}
