---
title: "NDR의 한계: 스텔스형 공격 대응의 현실적 문제"
date: 2025-05-02
draft: false
description: "NDR(Network Detection and Response)의 한계와 스텔스형 위협 대응을 위한 현실적인 접근 방안을 탐구합니다."
featured_image: "cdn/column/limitations-ndr-bpfdoor.jpg"
tags: ["NDR", "네트워크 보안", "스텔스 공격", "BPFdoor", "Symbiote", "LummaC2", "암호화 트래픽", "보안 솔루션", "PLURA-XDR"]
---

📡 **NDR**(Network Detection and Response)은 네트워크 트래픽 분석을 통해 위협을 탐지하는 보안 기술이지만,  
최근 SK텔레콤 해킹 사건처럼 고도화된 **스텔스형 공격** 앞에서는 분명한 기술적 한계를 드러냈습니다.

![NDR의 한계](https://blog.plura.io/cdn/column/limitations-ndr-bpfdoor.jpg)

<!--more-->

---

## 1. 최근 스텔스형 공격의 특징

* **BPFdoor** – 매직 패킷을 받기 전까지 ‘포트리스(portless)’ 상태로 은폐.  
* **Symbiote** – 리눅스 정상 프로세스에 기생하는 루트킷, 로그·/proc 조작 가능.  
* **LummaC2** – 난수형 주기·TLS 암호화 C2 통신으로 탐지면을 극소화.

이들은 모두 **전통적 시그니처·패턴 기반 보안**을 손쉽게 우회하도록 설계됐습니다.

---

## 2. NDR 기술의 명확한 한계 (요약)

| 구분 | 한계점 | 핵심 이유 |
|------|--------|-----------|
| **① 암호화 트래픽 분석 불가능** | TLS 1.3·QUIC·ESNI로 **내용 가시성 0** | 메타데이터만으로는 스텔스형 위협 식별 불가 |
| **② 행위 기반 탐지의 높은 오탐률** | 정상 세션과 미세 차이 → **오탐 & 미탐** | 경보 피로 (alert fatigue) 유발 |
| **③ 탐지 우회형 공격 대응 불가능** | BPFdoor 등은 **세션·포트 자체가 존재 안 함** | NDR의 탐지 범위 밖 |

---

## 3. NDR 기술의 명확한 한계 (상세)

### 🔍 1) 암호화 트래픽 분석 불가능

* 인터넷 트래픽 90 % 이상이 TLS 1.3·QUIC.  
* ESNI/Encrypted ClientHello 적용 시 **SNI·ALPN조차 숨겨져** 지문 기반 분류도 붕괴.  
* BPFdoor는 매직 패킷 전까지 트래픽 자체를 만들지 않아, 메타데이터 분석도 무력화.

### 🔍 2) 행위 기반 탐지의 높은 오탐률

* JA3/TLS 지문 충돌로 **같은 지문 ≠ 같은 앱** 사례 다수.  
* 미세 패턴 차이에 기대다 보니 정상 업무 트래픽까지 위협으로 오인 → **운영 효율 급감**.

### 🔍 3) 탐지 우회형 공격 대응 불가능

* 포트리스(backdoor-less)·루트킷 은폐·난수형 C2 주기가 **NDR이 의존하는 ‘행위 시그널’을 제거**.  
* 결과적으로 NDR은 “존재하지 않는 세션”을 탐지해야 하는 **논리적 모순**에 직면.

---

## 4. 한계를 극복하는 현실적 대안: **PLURA-XDR**

### ✅ PLURA-XDR의 통합 접근

1. **본문 로그 실시간 수집** – TLS 내부 요청·응답까지 가시화.  
2. **OWASP 기반 L7 분석** – 네트워크가 아닌 **애플리케이션 레이어**에서 직접 차단.  
3. **EDR·루트킷 탐지** – 커널/유저 공간 은폐 행위 식별.  
4. **AI 상관 분석 & 자동 대응** – 네트워크·호스트·로그를 한 그래프로 묶어 즉시 차단.

> **요약:** PLURA-XDR은 NDR이 놓치는 암호화·스텔스 구간을 **엔드포인트·로그·AI 상관 분석**으로 메우는 다층 방어 플랫폼입니다.

---

## 5. 결론: 통합 방어 전략이 답이다

스텔스형 위협 시대, **NDR**으로는 결코 완벽 대응이 불가능합니다.  
**PLURA-XDR**과 같은 **다층·통합 솔루션**을 적용해야만 실질적인 보안 효과를 얻을 수 있습니다.

**✅ PLURA-XDR = NDR의 한계를 보완하는 현실적 차세대 보안 솔루션.**

---

### 📖 **함께 읽기**
* ["기사: 기존 보안으론 못막아… 잇단 대형 해킹에 스텔스 위협 대응 촉구"](https://n.news.naver.com/article/018/0006002991)
* ["WAF vs IPS vs UTM 비교하여 웹 공격 최상의 제품 선택하기"](https://blog.plura.io/ko/column/waf_ips_utm_comparison/)
* ["Cisco Encrypted Traffic Analytics(ETA)의 한계"](https://community.cisco.com/t5/security-knowledge-base/cisco-eta-feature-encrypted-traffic-analysis-at-glance/ta-p/4783197)
