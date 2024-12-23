---
date: 2021-07-14T10:58:08-04:00
draft: false
title: "curl 프록시 옵션 설정"
description: "curl 명령어를 사용하여 프록시 경유 방법을 설명합니다."
featured_image: "cdn/tech/proxy_settings_with_curl-1.png"
tags: ["curl", "proxy", "프록시 설정"]
---

# curl 옵션 설정 중 프록시 경유하기

**다음은 테스트용 악성코드를 다운로드받는 예제입니다.**

```bash
curl -O -x "http://127.0.0.1:3128" http://www.eicar.org/download/eicar.com
curl -O --proxy "http://127.0.0.1:3128" http://www.eicar.org/download/eicar.com
curl -x localhost:3128 -I -L http://www.eicar.org/download/eicar.com
```

<!--more-->

`-x` 옵션뿐만 아니라 `--proxy`도 동일한 옵션으로 사용할 수 있습니다.

![proxy_settings_with_curl](https://blog.plura.io/cdn/tech/proxy_settings_with_curl-1.png)

## 📖 함께 읽기

- [Using cURL with Proxy](https://oxylabs.io/blog/curl-with-proxy)
- [cURL with Proxy Support](https://red.ht/2UKB3yC)
