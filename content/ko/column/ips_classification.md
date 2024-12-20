---
title: "침입차단시스템(IPS) 분류: NIPS, HIPS, 그리고 하이브리드"
date: 2024-02-23T12:58:00
draft: false
description: "IPS를 NIPS, HIPS, 하이브리드로 분류하여 각각의 특성과 적용 범위를 분석합니다."
featured_image: "cdn/column/ips_classification-1.jpg"
tags: ["IPS", "NIPS", "HIPS", "하이브리드 IPS"]
---

### 🔐 침입차단시스템(IPS) 분류: NIPS, HIPS, 그리고 하이브리드

침입차단시스템(IPS)은 다양한 유형으로 분류될 수 있으며, 보안 요구사항에 따라 NIPS(Network Intrusion Prevention Systems), HIPS(Host Intrusion Prevention Systems), 그리고 하이브리드 IPS로 나눌 수 있습니다. 각 분류는 작동 원리와 목적이 다르며, 보안 전략의 핵심 요소로 작용합니다.

<!--more-->

![IPS 분류](https://blog.plura.io/cdn/column/ips_classification-1.jpg)

---

### 1. **NIPS (Network Intrusion Prevention Systems)**

#### 정의
NIPS는 네트워크 내에서 데이터 흐름을 모니터링하여 악성 트래픽과 공격을 식별하고 차단하는 시스템입니다.

#### 주요 기능
- 네트워크 트래픽 패턴 분석
- 알려진 공격 및 비정상적인 트래픽 탐지
- 악성 트래픽 차단 및 격리

#### 적용 범위
네트워크 전체 또는 특정 세그먼트를 보호하며, 네트워크 경계에서 작동합니다.

---

### 2. **HIPS (Host Intrusion Prevention Systems)**

#### 정의
HIPS는 개별 호스트나 디바이스에 설치되어 운영되는 시스템으로, 해당 호스트에서 발생하는 악성 활동을 탐지하고 차단합니다.

#### 주요 기능
- 파일 시스템 변경, 메모리 호출, 레지스트리 설정 변경 모니터링
- 호스트 내부 이벤트 분석 및 악성 행위 차단

#### 적용 범위
특정 컴퓨터, 서버 등 소프트웨어가 설치된 개별 호스트를 대상으로 합니다.

---

### 3. **하이브리드 IPS (Hybrid IPS)**

#### 정의
하이브리드 IPS는 NIPS와 HIPS의 기능을 통합하여 네트워크와 호스트 보안을 동시에 제공합니다.

#### 주요 사례
- **CIPS (Cloud-based Intrusion Prevention Systems):** 클라우드 환경에서 네트워크와 호스트 보안을 모두 관리합니다.
- **VIPS (Virtual IPS):** 가상화된 환경 내에서 가상 네트워크와 가상 머신의 보안을 강화합니다.

---

### 4. **추가적인 IPS 분류**

#### **WIPS (Wireless Intrusion Prevention Systems)**
- 무선 네트워크 보안을 강화하며, 무단 접근 포인트(AP) 탐지 및 무선 트래픽 분석을 수행합니다.

#### **AIPS (Application-level IPS)**
- SQL 인젝션, 크로스 사이트 스크립팅(XSS) 등 애플리케이션 계층 공격을 탐지하고 방어합니다.

---

### 5. **IIPS: 통합 IPS 전략**

IIPS(Integrated Intrusion Prevention System)는 NIPS, HIPS, 하이브리드 IPS를 통합하여 다양한 보안 요구사항에 대응하는 체계적인 방어 전략입니다. 이를 통해 조직은 네트워크, 호스트, 애플리케이션 등 다양한 환경에서 포괄적인 보안 체계를 구축할 수 있습니다.

![하이브리드 IPS 분류](https://blog.plura.io/cdn/column/ips_classification-2.png)

---

### 🔗 참고 자료
- [1] 침입차단시스템(IPS) 역할 이해하기  
  https://blog.plura.io/ips-role
- [2] NDR의 한계: 해결 불가능한 미션  
  https://blog.plura.io/ndr-limitations

