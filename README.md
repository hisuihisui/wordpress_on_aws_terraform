# wordpress_on_aws_terraform
AWSにWordpressが動作する環境を作成するTerraformのコード

## ディレクトリ構成
environments    : 環境ごとの設定を定義
modules         : モジュールを定義
shared          : 共通の設定を定義し、environments にリンクを貼る

## シンボリックリンクの貼り方
```
ln -s リンクしたい実際のdir そのdirを呼び出す際のリンク名
```
