---
date: 2023-05-13
title: "제로 트러스트 아키텍처(ZTA)의 논리적 구성 요소"
description: "NIST SP 800-207에 정의된 Zero Trust Architecture의 구성 요소"
featured_image: ""
tags: ["Zero Trust", "ZTA", "보안", "NIST"]
---

![Zero Trust Architecture](https://github.com/user-attachments/assets/8e9b9633-782f-47c0-a981-6d64b2646455)

> **Zero Trust Architecture, NIST Special Publication 800-207**  
> 번역 by Google Translate

---

### 1. 정책 엔진 (PE, Policy Engine)
- **역할:** 주체에 대한 리소스 액세스 권한 부여 여부를 결정합니다.  
- **기능:** 
  - 외부 소스(예: CDM 시스템, 위협 인텔리전스) 및 엔터프라이즈 정책을 입력받아 액세스를 허용, 거부 또는 취소합니다.
  - 정책 관리자(PA)와 함께 동작하며 결정 내용을 기록하고 전달합니다.

---

### 2. 정책 관리자 (PA, Policy Administrator)
- **역할:** 주체와 리소스 간의 통신 경로를 설정하거나 종료합니다.  
- **기능:** 
  - 인증 토큰 또는 자격 증명을 생성합니다.
  - PE의 결정에 따라 세션을 승인하거나 종료하도록 PEP에 명령을 전달합니다.

---

### 3. 정책집행포인트 (PEP, Policy Enforcement Point)
- **역할:** 주체와 리소스 간의 연결을 활성화, 모니터링, 종료합니다.  
- **기능:** 
  - PA와 통신하며 요청을 전달하거나 정책 업데이트를 수신합니다.
  - 클라이언트 측(예: 랩톱 에이전트) 및 리소스 측(예: 게이트웨이)으로 나눌 수 있습니다.

---

### 4. 지속적인 진단 및 완화 (CDM, Continuous Diagnostics and Mitigation)
- **역할:** 기업 자산의 현재 상태 정보를 수집하고 소프트웨어 업데이트를 적용합니다.  
- **기능:** 
  - 정책 엔진에 자산 정보(운영 체제 상태, 무결성 여부 등)를 제공합니다.

---

### 5. 산업 규정 준수 (Industry Compliance)
- **역할:** 기업이 해당 규제 체제를 준수하도록 보장합니다.  
- **기능:** 
  - FISMA, 금융 및 의료 정보 보안 요구 사항에 대한 준수를 지원합니다.

---

### 6. 위협 인텔리전스 피드 (Threat Intelligence Feed)
- **역할:** 정책 엔진의 결정에 활용되는 정보를 제공합니다.  
- **기능:** 
  - 새로운 결함, 맬웨어, 공격에 대한 최신 정보를 제공합니다.

---

### 7. 네트워크 및 시스템 활동 로그 (Network and System Activity Logs)
- **역할:** 자산 로그, 네트워크 트래픽, 리소스 액세스 작업 등의 실시간 데이터를 집계합니다.  
- **기능:** 
  - 엔터프라이즈 정보 시스템의 보안 상태를 모니터링합니다.

---

### 8. 데이터 액세스 정책 (Data Access Policies)
- **역할:** 리소스에 대한 속성, 규칙, 정책을 정의합니다.  
- **기능:** 
  - 계정 및 애플리케이션/서비스에 대한 기본 액세스 권한을 제공합니다.

---

### 9. 엔터프라이즈 공개 키 인프라 (PKI, Public Key Infrastructure)
- **역할:** 인증서를 생성하고 기록합니다.  
- **기능:** 
  - 리소스, 주체, 서비스 및 애플리케이션에 대한 인증서를 발급합니다.

---

### 10. ID 관리 (IDM, Identity Management)
- **역할:** 엔터프라이즈 사용자 계정 및 ID 정보를 생성, 저장, 관리합니다.  
- **기능:** 
  - 주체의 역할, 액세스 속성, 자산 할당 정보를 포함합니다.

---

### 11. 통합보안이벤트관리 (SIEM, Security Information and Event Management)
- **역할:** 보안 정보를 수집하고 정책 개선에 활용합니다.  
- **기능:** 
  - 잠재적 공격 가능성을 경고하고 분석을 위해 데이터를 저장합니다.

---

### 참고 자료

1. NIST SP 800-207: [Zero Trust Architecture](https://csrc.nist.gov/publications/detail/sp/800-207/final)  
2. KISA 번역: "상시 진단 및 대응"  
3. Google Translate: "보안 정보 및 이벤트 관리"
