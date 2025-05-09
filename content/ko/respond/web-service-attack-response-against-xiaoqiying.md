---
date: 2023-02-20T02:00:00
draft: false
title: "웹 서비스 공격에 대응하기 against 샤오치잉(Xiaoqiying)"
description: ""
featured_image: "cdn/respond/web_service_attack_response_against_xiaoqiying-1.png"
tags: ["PLURA-SIEM", "WAF", "Post-body", "웹 보안", "크리덴셜 스터핑", "공격 대응"]
---

## 🏗️개요

웹 서비스를 보호하기 위한 필수적인 제품은 바로 **웹 방화벽(WAF, Web Application Firewall)** 입니다.  
네트워크 기반 침입 차단 시스템(NIPS, Network-based Intrusion Prevention System)과 병행 사용하는 경우도 있지만,  
NIPS는 현대적인 환경에서 적합하지 않으며 네트워크 복잡성 증가로 장애 가능성을 높이기 때문에 오히려 제거가 권장됩니다.
<!--more-->
![web_service_attack_response_against_xiaoqiying](https://blog.plura.io/cdn/respond/web_service_attack_response_against_xiaoqiying-1.png)

---

## 웹 방화벽(WAF)의 한계

**WAF가 차단하지 못한 공격은 어떻게 될까요?**

- 웹 방화벽(WAF)은 계정 탈취 공격인 **크리덴셜 스터핑(Credential Stuffing)** 에 대응할 수 없습니다.  
- 이미 언급했듯이, WAF가 놓친 공격을 **NIPS가 탐지할 가능성은 매우 낮습니다.**

---

## SIEM 솔루션의 역할

**통합 보안 이벤트 관리(SIEM) 솔루션은 모든 이벤트를 수집하여 상관 분석으로 이상 징후를 탐지합니다.**  
그러나 SIEM 자체적으로 분석할 수 있는 기능은 없으며, 보안 제품에서 탐지 정보를 포함한 로그를 수집해야만 동작합니다.

**예시:**  
| 보안 장비                        | 통과 (pass) | 차단 (deny) | 본문 정보 |
|----------------------------------|-------------|-------------|-----------|
| **방화벽 (Firewall)**            |      O      |      O      |      X    |
| **네트워크 기반 침입 차단 시스템 (NIPS)** |      O      |      O      |      X    |
| **웹 방화벽 (WAF)**              |      O      |      O      |      X    |

---

## 요청 본문(Post-body)와 SIEM의 한계

### 요청 본문(Post-body)란?

- 사용자가 브라우저에서 입력한 데이터를 웹 서버로 전송하는 데이터 영역입니다.  
  - 예: 로그인 시 입력하는 아이디와 비밀번호 등.  
- 공격자는 여기에 **SQL 인젝션**이나 **크로스사이트스크립팅(XSS)** 과 같은 악성 데이터를 삽입할 수 있습니다.

**문제점: 요청 본문은 웹 서버 로그에 기록되지 않습니다.**

웹 로그는 접속자의 IP, 브라우저 종류, 쿠키, 접근 경로 등 **헤더 정보만 기록**하므로,  
SIEM이 웹 로그를 분석하더라도 이상 징후 탐지가 어려운 구조적 한계가 있습니다.

---

## PLURA-SIEM의 해결책

**PLURA-SIEM**은 글로벌 특허를 기반으로 **요청 본문(Post-body)** 을 웹 로그에 기록하고, 이를 분석하여 이상 징후를 탐지합니다.  
이 혁신적인 기능은 SIEM 솔루션의 한계를 극복하고 보다 효과적인 공격 대응을 제공합니다.

---

## ✍️네 줄 요약

1) 웹 방화벽(WAF)은 **크리덴셜 스터핑 공격**에 대응할 수 없다.  
2) SIEM 솔루션은 **웹 로그만으로 이상 징후를 탐지하기 어렵다.**  
3) 요청 본문(Post-body)은 **웹 로그에 기록되지 않는다.**  
4) **PLURA-SIEM**은 요청 본문을 기록 및 분석하여 **이상 징후를 탐지한다.**

---

## 📖 함께 읽기

- [크리덴셜 스터핑 공격 대응하기](https://blog.plura.io/ko/respond/credential-stuffing-countermeasures/)
