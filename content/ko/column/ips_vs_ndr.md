---
title: "IPS와 NDR 차이와 한계"
date: 2023-02-23
draft: false
description: "IPS와 NDR의 주요 차이점과 한계를 분석하고, 호스트 기반 보안 시스템의 필요성을 논의합니다."
featured_image: "cdn/column/ips_vs_ndr.jpg"
tags: ["IPS", "NDR", "보안", "네트워크 보안", "암호화 패킷", "Endpoint Security"]
---

🔍 **IPS(Intrusion Prevention System)**와 **NDR(Network Detection and Response)**은 네트워크 보안 기술로, 각각 다른 목적과 구현 방식을 가지고 있습니다.  
이 문서에서는 두 기술의 차이와 한계를 분석하고, 암호화 환경에서의 보안 문제를 해결하기 위한 대안을 제시합니다.

![IPS와 NDR의 차이](https://blog.plura.io/cdn/column/ips_vs_ndr.jpg)

<!--more-->
---

### 1. **IPS와 NDR의 주요 차이점**
#### 💡 정의
- **IPS**: 네트워크 내부의 침입을 실시간으로 탐지하고 차단하는 시스템.
- **NDR**: 네트워크 트래픽 데이터를 모니터링하고 분석하여, 고도화된 위협을 탐지하고 대응하는 시스템.

#### 🔑 주요 차이
| **구분**     | **IPS**                                          | **NDR**                                   |
|--------------|--------------------------------------------------|-------------------------------------------|
| **목적**      | 실시간 침입 차단 및 방어                           | 네트워크 이상 탐지 및 분석                  |
| **위치**      | 네트워크 경계                                   | 네트워크 내부                              |
| **분석 방식** | 패킷 또는 트래픽 규칙 기반 분석                   | 머신러닝 및 AI 기반 고도화된 트래픽 분석      |
| **대응 방법** | 침해 발생 시 트래픽 차단                           | 이상 탐지 후 대응 방안 제시 또는 자동 대응    |

---

### 2. **암호화된 패킷 분석의 한계**
#### 🔒 암호화된 패킷과 분석 문제
- **IPS와 NDR의 공통 한계**:
  - TLS/SSL 암호화된 패킷의 본문은 키가 없으면 분석 불가능.
  - 패킷의 메타데이터(크기, IP 주소, 포트 번호 등)를 활용하여 간접적으로 이상 탐지 수행.

#### 🔍 NDR의 접근법
- **메타데이터 분석**:
  - 트래픽 흐름과 패턴을 기반으로 보안 위협 탐지.
  - 머신러닝을 통해 알려지지 않은 위협에도 대응 가능.
- **암호화 트래픽 분석**:
  - 암호화되지 않은 일부 구간(예: DNS 요청)을 분석하거나, 암호화 트래픽의 비정상적인 증상을 탐지.

---

### 3. **암호화 환경에서의 대응 방안**
#### 🌐 **TLS/SSL 해제와 패킷 분석**
- IPS와 NDR은 **SSL/TLS 해제**를 통해 암호화되지 않은 패킷을 분석할 수 있습니다.
- 단, SSL 해제는 트래픽 성능과 개인 정보 보호 측면에서 논란이 될 수 있습니다.

#### 🚧 **오탐 문제**
- 암호화된 환경에서 메타데이터 분석만으로는 정확도가 낮아 오탐이 발생할 가능성이 높습니다.
- SSH, RDP, PKI 등 암호화된 프로토콜은 본문 분석이 어려워 이상 탐지의 한계가 존재합니다.

---

### 4. **호스트 기반 보안 시스템의 필요성**
#### 🛡️ **호스트 기반 보안의 장점**
- **본문 분석 가능**:
  - 암호화된 통신 내부의 데이터를 직접 탐지 및 분석 가능.
- **실시간 탐지 및 대응**:
  - 네트워크와 독립적으로 호스트 내부의 위협 탐지.
- **성능 영향 최소화**:
  - 호스트 자원 활용이 효율적이며, 네트워크 성능에 영향을 미치지 않음.

#### 🤝 **통합 보안 전략**
- IPS와 NDR의 네트워크 중심 보안을 보완하기 위해, 호스트 기반 보안 시스템(EDR)을 함께 활용.
- **복합 방어 체계**:
  - 네트워크와 호스트 보안을 결합하여 다각도의 보안 체계 구축.

---

### ✍️ 결론
#### 🔑 IPS와 NDR의 역할
- IPS는 침입 차단에, NDR은 이상 탐지와 분석에 강점을 지니며, 서로 보완적인 역할을 합니다.
- 암호화된 트래픽 환경에서는 메타데이터 분석의 한계로 인해 오탐 가능성이 높아지는 문제가 있습니다.

#### 🔒 호스트 기반 보안의 필요성
- SSH, RDP와 같은 암호화된 환경에서는 **호스트 기반 보안 시스템(EDR)**이 더 효과적일 수 있습니다.
- IPS, NDR, EDR을 통합적으로 활용하여 다층적 보안을 구현하는 것이 이상적입니다.

✅ **결론적으로, 단일 보안 솔루션으로는 완벽한 보안을 보장할 수 없습니다.**  
보안 환경의 복잡성을 고려하여, IPS, NDR, EDR을 조합한 다층적 접근이 필요합니다.

---

### 🔗 참고 자료
- ["침입차단시스템(IPS)에 대한 이해 with ChatGPT"](http://blog.plura.io/?p=18840)