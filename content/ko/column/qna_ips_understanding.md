---
title: "침입차단시스템(IPS)에 대한 이해"
date: 2023-02-23
draft: false
description: "IPS, WAF, SIEM, 및 암호화된 패킷 분석에 대한 이해와 활용 방안"
featured_image: "/cdn/column/qna_ips_understanding.jpg"
tags: ["IPS", "네트워크보안", "암호화 패킷 분석", "호스트보안", "NDR", "EDR", "WAF", "SIEM", "Zeek", "Wireshark", "tcpdump"]
---

🔐침입차단시스템(IPS, Intrusion Prevention System)은 네트워크 보안의 핵심 요소로, 네트워크 및 호스트 기반 보안 솔루션들과 함께 사용되어 다양한 보안 위협에 대응합니다. 그러나 IPS는 암호화된 패킷 분석에서 한계가 있으며, 이를 보완하기 위해 WAF와 EDR 같은 기술이 필요합니다.

![IPS 이해](https://blog.plura.io/cdn/column/qna_ips_understanding.jpg)

<!--more-->

---

### 1. **네트워크 IPS와 암호화된 패킷 분석**

네트워크 IPS는 일반적으로 암호화된 패킷 분석이 어렵습니다. 암호화된 트래픽은 페이로드를 숨기기 때문에 패킷의 내용을 해독하지 못하며, 다음과 같은 제한이 있습니다:

- **한계:** 암호화된 패킷은 분석이 불가능하며, TLS/SSL 디코딩을 통한 일부 제한적 분석만 가능합니다.
- **대안:** TLS/SSL 디코더, 웹방화벽(WAF), SIEM 등 다른 보안 도구와 결합하여 네트워크 보안을 강화합니다.

---

### 2. **암호화된 패킷과 네트워크 IPS의 유용성**

암호화된 패킷만 있는 환경에서 네트워크 IPS의 유용성은 다음과 같습니다:

- **메타데이터 분석:** 패킷의 헤더 정보 분석을 통해 일부 이상 징후 탐지
- **한계:** 페이로드에 대한 세부 분석 불가능, 오탐(오경보) 가능성 증가
- **보완책:** WAF와 SIEM 같은 보안 솔루션으로 보완

---

### 3. **TLS/SSL 디코더 도구**

암호화된 패킷 분석에는 다음과 같은 도구가 활용됩니다:

- **Wireshark, tcpdump, tshark:** TLS/SSL 트래픽 디코딩 가능
- **WAF:** 웹 애플리케이션 트래픽 분석 및 취약점 방어

---

### 4. **WAF와 네트워크 IPS 비교**

웹방화벽(WAF)은 암호화된 트래픽 분석에서 네트워크 IPS보다 더 나은 선택이 될 수 있습니다:

- **WAF:** HTTPS 트래픽의 SSL/TLS 디코딩 및 심층 분석 가능
- **네트워크 IPS:** 암호화된 트래픽 분석은 제한적이나, 네트워크 전체를 모니터링하여 악성 트래픽 탐지
- **결론:** WAF와 네트워크 IPS는 서로 보완적으로 사용되어야 함

---

### 5. **WAF, EDR, 및 SIEM 활용**

암호화된 패킷 분석에서 네트워크 IPS의 한계를 보완하기 위해 다음과 같은 솔루션을 활용합니다:

#### **WAF(Web Application Firewall):**
- 악성 웹 트래픽 차단 (예: SQL Injection, XSS)
- HTTPS 트래픽 분석 가능

#### **EDR(Endpoint Detection and Response):**
- 호스트 기반 보안으로 암호화된 트래픽 내 악성 활동 탐지
- 시스템 행위 분석 및 위협 차단

#### **SIEM(Security Information and Event Management):**
- 네트워크 및 시스템 로그 통합 분석
- 보안 사고 탐지 및 대응

---

### 6. **PLURA-XDR의 WAF와 SIEM 활용**

Plura.io는 다음과 같은 보안 솔루션을 제공합니다:

1. **WAF:**
   - SQL Injection, 크로스 사이트 스크립팅(XSS) 차단
   - 웹 애플리케이션의 취약점 보호

2. **SIEM:**
   - 로그 데이터 수집 및 분석
   - 악성 행위 및 보안 위협 탐지

PLURA-XDR의 WAF와 SIEM은 보안 운영과 관제 업무에서 높은 성과를 제공합니다.

---

### ✍️ 결론

네트워크 IPS는 암호화된 패킷 분석에서 한계가 있으나, WAF와 EDR, SIEM 같은 솔루션과 함께 사용하여 보안성을 높일 수 있습니다. PLURA-XDR의 서비스를 통해 보다 안전한 네트워크 환경을 구축할 수 있습니다.

---
