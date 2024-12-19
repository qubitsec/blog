---
date: 2021-08-14T00:00:00
description: 
featured_image: 
tags: 
title: "CentOSでcurlを手動更新する方法"
---

![blog_banner_20210817_1](https://github.com/user-attachments/assets/ddf3d087-3fae-4c4b-be71-68d646332700)

## epel-releaseのインストール
```bash
# yum -y update epel-release
```

## 新しいファイル /etc/yum.repos.d/city-fan.repo を作成
```bash
# vi /etc/yum.repos.d/city-fan.repo
```

## 以下の内容を貼り付け
```bash
[CityFan]
name=City Fan Repo
baseurl=http://www.city-fan.org/ftp/contrib/yum-repo/rhel$releasever/$basearch/
enabled=1
gpgcheck=0
```

## バージョン確認
```bash
# curl -V
例) curl 7.78.0 (x86_64-redhat-linux-gnu) // 2021-08-14
```
