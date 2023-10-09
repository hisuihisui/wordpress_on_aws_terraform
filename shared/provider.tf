terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.6.0"

  # tfstateの保存先
  backend "s3" {
    bucket = "tfstate-animevoyager"
    region = "ap-northeast-1"
    # バケット内の保存先
    key = "tfstate/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-northeast-1"
}
