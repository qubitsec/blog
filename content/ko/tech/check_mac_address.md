---
date: 2021-07-14T11:58:08-04:00
draft: false
title: "MAC 주소 확인하기"
description: 
featured_image: "cdn/tech/check_mac_address-1.png"
tags: ["MAC 주소", "네트워크", "PC 정보"]
---

PC 서버의 고유 정보를 확인하고 활용하기 위해 **MAC 주소**를 확인하는 방법을 안내합니다.

<!--more-->
---
![check_mac_address](https://blog.plura.io/cdn/tech/check_mac_address-1.png)

## 명령 관리자 실행

먼저, `명령 관리자(cmd)`를 실행합니다.

![cmd](https://github.com/user-attachments/assets/904a77ef-fe8d-4590-a336-1ca42daa2135)

---

## `ipconfig /all` 명령어 실행

명령 관리자에서 다음 명령어를 실행합니다:

```bash
ipconfig /all
```

![ipconfig](https://github.com/user-attachments/assets/80ce24e4-b4d8-45f1-9f1b-e41af052c497)

---

## MAC 주소 확인

`ipconfig /all` 명령어 실행 결과에서 각 어댑터의 `물리적 주소(Physical Address)` 항목이 해당 어댑터의 MAC 주소입니다.

---

