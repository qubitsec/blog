---
date: 2021-07-16T00:00:00
draft: false
title: "로깅(Logging) 을 위해 SSD 사용하기"
description: 
featured_image: "cdn/tech/check_disk_type_for_logging-1.png"
tags: 
---

동시 접속이 증가하면 성능에 영향을 미치는 요소가 많습니다.

그 중에서도 웹 시스템의 경우, 액세스가 늘어나면 로깅(logging) 또한 증가합니다.

'/var/log'가 HDD보다 SSD일 경우 시스템의 안정적인 운영에 도움이 됩니다.

<!--more-->
---

사용 중인 디스크가 SSD인지 HDD인지 확인하기 위한 명령어는 다음과 같습니다.

```bash
cat /sys/block/sda/queue/rotational
```
0: SSD <br>
1: HDD <br>

<br>

## 📖 함께 읽기
* [How to know if a disk is an SSD or an HDD](https://unix.stackexchange.com/questions/65595/how-to-know-if-a-disk-is-an-ssd-or-an-hdd)
