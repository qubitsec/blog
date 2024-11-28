---
date: 2021-07-16T00:00:00
description: 
featured_image: 
tags: 
title: "ロギング(Logging)にSSDを使用する"
---

![blog_banner_20210716_1](https://github.com/user-attachments/assets/d7ceea36-2dfb-4493-8709-39d7d9888bd7)

<br>

同時接続が増加すると、パフォーマンスに影響を与える要素が多くなります。

特にウェブシステムでは、アクセス数の増加に伴い、ロギング(logging)も増加します。

'/var/log' がHDDよりもSSDである場合、システムの安定した運用に役立ちます。

現在使用しているディスクがSSDかHDDかを確認するコマンドは以下の通りです。

```bash
cat /sys/block/sda/queue/rotational
```
0: SSD <br>
1: HDD <br>

<br>

## 参考リンク
https://unix.stackexchange.com/questions/65595/how-to-know-if-a-disk-is-an-ssd-or-an-hdd
