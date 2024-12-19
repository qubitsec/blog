---
date: 2021-07-14T10:58:08-04:00
draft: false
title: "curl プロキシオプション設定"
description: "curl コマンドを使用してプロキシを経由する方法を説明します。"
featured_image: "cdn/tech/proxy_settings_with_curl-1.png"
tags: ["curl", "proxy", "プロキシ設定"]
---

# curl オプション設定でプロキシを経由する方法

**以下はテスト用マルウェアをダウンロードする例です。**

```bash
curl -O -x "http://127.0.0.1:3128" http://www.eicar.org/download/eicar.com
curl -O --proxy "http://127.0.0.1:3128" http://www.eicar.org/download/eicar.com
curl -x localhost:3128 -I -L http://www.eicar.org/download/eicar.com
```

<!--more-->

`-x` オプションだけでなく、`--proxy` も同様に使用できます。

![proxy_settings_with_curl](https://blog.plura.io/cdn/tech/proxy_settings_with_curl-1.png)

## 参考リンク

- [Using cURL with Proxy](https://oxylabs.io/blog/curl-with-proxy)
- [cURL with Proxy Support](https://red.ht/2UKB3yC)
