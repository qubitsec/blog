---
date: 2021-08-14T00:00:00
description: 
featured_image: 
tags: 
title: "How to Manually Update curl on CentOS"
---

![1](https://github.com/user-attachments/assets/912f4318-5e66-4f16-a963-9d5a44afeab1)

## need epel-release
```bash
# yum -y update epel-release
```

## create a new file /etc/yum.repos.d/city-fan.repo
```bash
# vi /etc/yum.repos.d/city-fan.repo
```

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
