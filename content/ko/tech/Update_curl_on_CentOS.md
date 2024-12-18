---
date: 2021-08-14T00:00:00
draft: false
title: "How to Manually Update curl on CentOS"
description: 
featured_image: "cdn/tech/update_curl_on_centos-1.png"
tags: 
---

## need epel-release
```bash
# yum -y update epel-release
```
## create a new file /etc/yum.repos.d/city-fan.repo
```bash
# vi /etc/yum.repos.d/city-fan.repo
```
<!--more-->

## Paste the following contents:
```bash
[CityFan]
name=City Fan Repo
baseurl=http://www.city-fan.org/ftp/contrib/yum-repo/rhel$releasever/$basearch/
enabled=1
gpgcheck=0
```

## Check version
```bash
# curl -V
ex) curl 7.78.0 (x86_64-redhat-linux-gnu) // 2021-08-14
```
