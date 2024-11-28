---
date: 2021-07-19T00:00:00
description: 
featured_image: 
tags: 
title: "有害サイトブロックリストのダウンロード"
---

![blog_banner_20210727_1](https://github.com/user-attachments/assets/0eb0ba7d-33bd-425b-b8cb-cbe01d06f3d1)

squidGuardでShallaブラックリストを定期的にダウンロードし、同期を行うためのスクリプト

```bash
# vi squidguard-update-blacklist.sh
#!/bin/sh

# システム設定に応じてこのセクションを構成してください
squidGuardpath="/usr/bin/squidGuard"
squidpath="/usr/sbin/squid"
httpget="/usr/bin/wget"
tarpath="/bin/tar"
chownpath="/bin/chown"

dbhome="/var/lib/squidGuard/db/" # squidguard.confと同じ
dbhomeBL="/var/lib/squidGuard/db/BL" # squidguard.confと同じ
squidGuardowner="squid."
workdir="/tmp"

# 最新のShallaブラックリストをダウンロード
shallalist=”http://www.shallalist.de/Downloads/shallalist.tar.gz”
$httpget $shallalist -O $workdir/shallalist.tar.gz || exit 1

#cp /root/shallalist.tar.gz $workdir/shallalist.tar.gz
$tarpath xzf $workdir/shallalist.tar.gz -C $workdir || exit 1

# 新しいローカルデータベースを作成
rm -r $dbhomeBL
rm -rf $workdir/shallalist.tar.gz
mv $workdir/BL $dbhome

# selinux
chcon -R -t squid_cache_t /var/lib/squidGuard
semanage fcontext -a -t squid_cache_t /var/lib/squidGuard

# クリーンアップ
$squidGuardpath -C all
$squidpath -k reconfigure
$chownpath -R $squidGuardowner $dbhome
```

<br>

## 参考リンク
http://www.shallalist.de/ <br>
https://gist.github.com/omtinez/8e05f4609cec76edb00d9420234b2ac3
