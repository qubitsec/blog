---
date: 2021-07-14T11:58:08-04:00
title: "MAC 주소 확인하기"
description: "PC 서버의 고유 정보를 확인하기 위해 MAC 주소를 사용하는 방법을 안내합니다."
featured_image: 
tags: ["MAC 주소", "네트워크", "PC 정보"]
---

![MAC 주소 확인](https://github.com/user-attachments/assets/f8404547-9de5-4a25-bc89-ccc381f47fdf)

PC 서버의 고유 정보를 확인하고 활용하기 위해 **MAC 주소**를 확인하는 방법을 안내합니다.

---

## 명령 관리자 실행

먼저, **명령 관리자**(cmd)를 실행합니다.

![명령 관리자 실행](https://github.com/user-attachments/assets/8732e630-b4f6-4458-87ae-1ff23a7d23d1)

---

## `ipconfig /all` 명령어 실행

명령 관리자에서 다음 명령어를 실행합니다:

```bash
ipconfig /all
```

![ipconfig 실행](https://github.com/user-attachments/assets/4c057267-956c-4644-a16d-5c29b716ed6f)

---

## MAC 주소 확인

`ipconfig /all` 명령어 실행 결과에서 각 어댑터의 **물리적 주소(Physical Address)** 항목이 해당 어댑터의 MAC 주소입니다.

---

