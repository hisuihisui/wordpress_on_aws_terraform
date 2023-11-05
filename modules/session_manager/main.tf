# AmazonSSMManagedInstanceCoreを参照
data "aws_iam_policy" "ssm_core" {
  name = "AmazonSSMManagedInstanceCore"
}

# 操作ログを保存するためにS3への操作権限を追加
data "aws_iam_policy_document" "ec2_ssm_policy_doc" {
  source_policy_documents = [data.aws_iam_policy.ssm_core.policy]

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${var.log_bucket_arn}/session_manager/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetEncryptionConfiguration"
    ]
    resources = [
      "*"
    ]
  }
}

# SSMを使用するためのIAMポリシーの作成
resource "aws_iam_policy" "ec2_ssm_policy" {
  name   = "ec2_ssm_policy"
  policy = data.aws_iam_policy_document.ec2_ssm_policy_doc.json
}

# IAMポリシーをIAMロールに紐づける
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = var.role_name
  policy_arn = data.aws_iam_policy.ssm_core.arn
}

# Session Managerの設定
resource "aws_ssm_document" "session_manager_prefs" {
  name            = var.ssm_document_name
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName        = var.log_bucket_name
      s3KeyPrefix         = "session_manager/"
      s3EncryptionEnabled = true
    }
  })
}
