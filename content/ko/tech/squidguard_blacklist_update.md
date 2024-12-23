---
date: 2021-07-19T00:00:00
draft: false
title: "유해차단 목록 다운받기"
description: 
featured_image: "cdn/tech/squidguard_blacklist_update-1.png"
tags: 
---

squidGuard 에서 Shalla 블랙 리스트를 주기적으로 다운받아 동기화를 위한 스크립트
<!--more-->

```bash
# vi squidguard-update-blacklist.sh
#!/bin/sh

# Configure this section according to your system settings
squidGuardpath="/usr/bin/squidGuard"
squidpath="/usr/sbin/squid"
httpget="/usr/bin/wget"
tarpath="/bin/tar"
chownpath="/bin/chown"

dbhome="/var/lib/squidGuard/db/" # same as squidguard.conf
dbhomeBL="/var/lib/squidGuard/db/BL" # same as squidguard.conf
squidGuardowner="squid."
workdir="/tmp"

# download actual shalla’s blacklist
shallalist=”http://www.shallalist.de/Downloads/shallalist.tar.gz”
$httpget $shallalist -O $workdir/shallalist.tar.gz || exit 1

#cp /root/shallalist.tar.gz $workdir/shallalist.tar.gz
$tarpath xzf $workdir/shallalist.tar.gz -C $workdir || exit 1

# create new local database
rm -r $dbhomeBL
rm -rf $workdir/shallalist.tar.gz
mv $workdir/BL $dbhome

# selinux
chcon -R -t squid_cache_t /var/lib/squidGuard
semanage fcontext -a -t squid_cache_t /var/lib/squidGuard

# clean-up
$squidGuardpath -C all
$squidpath -k reconfigure
$chownpath -R $squidGuardowner $dbhome
```

<br>

## 📖 함께 읽기
* [shallalist](http://www.shallalist.de/)
* [Blacklist auto-update for SquidGuard](https://gist.github.com/omtinez/8e05f4609cec76edb00d9420234b2ac3)
