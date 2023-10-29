terraform {
  # tfstateの保存先
  backend "s3" {
    bucket = "tfstate-animevoyager"
    region = "ap-northeast-1"
    # バケット内の保存先
    key     = "tfstate/terraform.tfstate"
    encrypt = true
  }
}
