# wordpress_on_aws_terraform
AWSにWordpressが動作する環境を作成するTerraformのコード

## ディレクトリ構成
environments    : 環境ごとの設定を定義 <br>
modules         : モジュールを定義 <br>
services        : サービスごとにフォルダを分ける <br>

## ファイルのフォーマット
```
terraform fmt -recursive
```

## ルール
・セキュリティグループのみでモジュール化せず、使用したいリソース内で定義する<br>
・vpcは各サービスでmain.tfに記載し、モジュール化しない<br>
