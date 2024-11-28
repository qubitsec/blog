---
date: 2021-07-14T10:58:08-04:00
title: "curl プロキシオプション設定"
description: "curl コマンドを使用してプロキシを経由する方法を説明します。"
featured_image: ""
tags: ["curl", "proxy", "プロキシ設定"]
---

![blog_banner_20210714_3](https://github.com/user-attachments/assets/cb7452ba-b166-4f9f-affd-2dd4aa91540c)

# curl オプション設定でプロキシを経由する方法

**以下はテスト用マルウェアをダウンロードする例です。**

```bash
curl -O -x "http://127.0.0.1:3128" http://www.eicar.org/download/eicar.com
curl -O --proxy "http://127.0.0.1:3128" http://www.eicar.org/download/eicar.com
curl -x localhost:3128 -I -L http://www.eicar.org/download/eicar.com
```

`-x` オプションだけでなく、`--proxy` も同様に使用できます。

## 参考リンク

- [Using cURL with Proxy](https://oxylabs.io/blog/curl-with-proxy)
- [cURL with Proxy Support](https://red.ht/2UKB3yC)
