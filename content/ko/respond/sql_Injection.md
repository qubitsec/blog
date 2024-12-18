---
date: 2022-03-21T04:00:00
draft: false
title: "SQL 인젝션"
description: 
featured_image: "cdn/respond/sql_injection-1.png"
tags: ["SQL Injection", "보안 취약점", "데이터 유출", "웹 해킹", "PLURA"]
---

B 기업은 오랫동안 SQL 인젝션에 대응하기 위해 노력해왔지만, 해커들의 공격 수법은 날로 정교해지고 있습니다.  
공격 IP 주소는 국내뿐 아니라 해외 IP도 사용되며, 특히 **주말과 휴일의 새벽 시간** 등 대응이 취약한 시간대를 노리고 공격이 집중됩니다.  

보안 관제 전문 회사의 24시간 관제 서비스조차 실시간 대응은 어려운 경우가 많으며,  
기업이 자체적으로 24시간, 365일 관제를 운영하는 것은 거의 불가능에 가깝습니다.
<!--more-->
![sql_injection](https://blog.plura.io/cdn/respond/sql_injection-1.png)

---

## 대응 방법

SQL 인젝션 공격은 단 한 번의 성공으로도 대량의 고객 정보와 기밀 정보가 유출될 수 있는 심각한 위협입니다.  
또한 해커들은 **다양한 우회 패턴**을 사용하기 때문에, **패턴 기반 대응 방식**으로는 전문 해커 그룹의 공격을 효과적으로 차단하기 어렵습니다.  

> **PLURA는 SQL 인젝션 공격 시도가 단 한 번이라도 발생하면, 해당 IP 주소의 접속을 즉시 차단합니다.**  
> 따라서 어떤 형태의 SQL 인젝션 공격이라도 효과적으로 대응할 수 있습니다.

---

## 관련 영상

- **해킹 탐지 시연 > 데이터 유출 탐지 (SQL 인젝션):**  
  [https://youtu.be/Qp-JbyZ_G1k?si=7bd8eHbK--mmgdhH](https://youtu.be/Qp-JbyZ_G1k?si=7bd8eHbK--mmgdhH)
