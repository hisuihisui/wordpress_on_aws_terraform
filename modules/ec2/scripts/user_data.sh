#!/bin/bash

# Nginxインストール
yum install -y nginx

# 自動起動設定
systemctl enable nginx

# 起動
systemctl start nginx
