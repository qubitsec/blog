---
title: "침입차단시스템(IPS) 이해하기"
date: 2023-12-19
draft: false
description: "침입차단시스템(IPS)을 OSI 모델 기반으로 분석하고, 네트워크 및 호스트 보안의 포괄적 전략으로 이해합니다."
featured_image: "cdn/column/ips_understanding.png"
tags: ["IPS", "OSI 모델", "보안"]
---

### 🛡️ 침입차단시스템(IPS) 이해하기

침입차단시스템(IPS, Intrusion Prevention System)은 OSI(Open Systems Interconnection) 모델을 기반으로 네트워크 및 호스트에서 발생하는 보안 위협을 탐지하고 방지하는 포괄적인 시스템입니다. IPS는 다양한 계층에서 작동하며, 네트워크와 호스트를 포함한 다층적 보안 전략의 핵심 요소로 작용합니다.

![IPS 이해](https://blog.plura.io/cdn/column/ips_understanding-1.png)

<!--more-->

---

### 1. **IPS와 OSI 모델 기반 보안 대응**

#### **Layer 3: 네트워크 계층**
- **IP 주소 기반 필터링:** 스푸핑(Spoofing) 및 소스 라우팅(Source Routing) 공격 차단
- **라우팅 규칙:** 네트워크 간 트래픽 제어 및 접근 제한

#### **Layer 4: 전송 계층**
- **포트 번호 기반 필터링:** 포트 스캐닝, SYN 플러드 같은 DoS 공격 방지
- **세션 관리:** TCP/UDP 세션 추적 및 비정상 트래픽 감지

#### **Layer 7: 응용 계층**
- **HTTP 트래픽 분석:** WAF(Web Application Firewall)를 통해 SQL 인젝션, XSS, 웹 쉘 업로드 방지
- **암호화된 트래픽:** 암호화된 데이터 분석의 한계를 보완하기 위해 호스트 기반 보안 솔루션 필요

---

### 2. **네트워크 기반 보안 솔루션: 방화벽과 WAF**

#### **네트워크 계층 및 전송 계층: 방화벽(Firewall)**
- **IP와 포트 필터링:** 네트워크 보안 경계를 설정하고 불필요한 트래픽 차단
- **상태 기반 검사(Stateful Inspection):** 트래픽 연결 상태를 추적하여 악성 트래픽 차단

#### **응용 계층: 웹방화벽(WAF)**
- **웹 요청 검사:** 웹 애플리케이션 대상 공격 차단
- **맞춤형 정책:** 애플리케이션 요구사항에 따른 세밀한 보안 정책 설정

---

### 3. **호스트 기반 보안 솔루션의 중요성**

#### **Layer 7 암호화된 트래픽 대응**
- 네트워크 기반 대응의 한계를 보완하기 위해 호스트 기반 보안 솔루션이 필요합니다.

#### **호스트 기반 솔루션**
1. **안티바이러스/안티멀웨어:** 파일 시스템에서 악성 소프트웨어 탐지 및 제거
2. **엔드포인트 감지 및 대응(EDR):** 시스템 행위 분석 및 위협 탐지
3. **데이터 손실 방지(DLP):** 민감한 데이터의 유출 방지
4. **애플리케이션 화이트리스팅:** 승인된 소프트웨어만 실행 허용
5. **보안 정보 및 이벤트 관리(SIEM):** 로그 분석 및 보안 사고 탐지

---

### 4. **IPS의 포괄적 정의**

#### **결론**
- IPS는 단일 제품이나 기술이 아닌, **네트워크와 호스트를 포함하는 포괄적인 보안 체계**를 의미합니다.
- 네트워크 계층과 전송 계층에서 방화벽(Firewall)이, 응용 계층에서 WAF(Web Application Firewall)가 주요 역할을 담당합니다.
- 암호화된 트래픽 분석 한계를 극복하기 위해, 호스트 기반 솔루션(EDR, DLP 등)과의 통합이 필수적입니다.

### ✍️ "침입차단시스템(IPS)은 단일 제품 영역이 아닙니다. 여러 네트워크 계층과 호스트 보안을 포함하는 포괄적인 의미로 침입을 차단하는 모든 시스템을 일컫는 용어입니다. by PLURA"

---

### 🔗 참고 자료
- [1] 침입차단시스템(IPS) 분류 NIPS & HIPS & 하이브리드  
- [2] 침입차단시스템(IPS)에 대한 이해  
- [3] WAF vs IPS vs UTM 비교하여 웹 공격 최상의 제품 선택하기  
- [4] IPS와 NDR 차이와 한계  
- [5] NDR의 한계: 해결 불가능한 미션  

---