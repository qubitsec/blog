---
date: 2023-05-22
description: 
featured_image: 
tags: 
title: "PLURA XDR 철학"
---

![xdr_01](https://github.com/user-attachments/assets/170046f6-0e88-4632-b347-290ce03c57f3)

> “보안은 단일 제품이 아닌 플랫폼에서 기본적으로 통합되어야 한다.”  
> – 팔로알토 CPO 리 클라리치(Lee Klarich, Palo Alto Networks)

정보보안 시스템의 체계는 1990년대부터 **네트워크 경계 보안(Network Perimeter Security Model) 중심**이었습니다.

네트워크 접속 지점을 단일화한 후, 단일 접속지점에서 강력한 보안 평가 및 통제를 적용하는 구조입니다. 이를 위해 단일 제품이 아닌 여러 제품을 네트워크 상에 배치하여 서로 다른 공격에 대응하는 다단계 방식입니다.

네트워크 경계 보안(Network Perimeter Security Model) 제품 분류는 다음과 같습니다:
1. 방화벽(Firewall)
2. 통합위협관리(UTM, Unified Threat Management)
3. 웹방화벽(WAF, Web Application Firewall)
4. 침입차단시스템(IPS, Intrusion Prevention System)
5. 침입탐지시스템(IDS, Intrusion Detection System)
6. 네트워크탐지와대응(NDR, Network Detection and Response)  
   
![1990_Network_Perimeter_Security_Model-600x308](https://github.com/user-attachments/assets/7edf85a3-b7b4-42c7-9b40-6dcaecf8b9f5)

2000년대에는 단일 제품의 한계를 경험하며 해당 제품들을 연동해야 한다는 개념이 부각되었습니다.  
이로 인해 **로그관리시스템(LMS, Log Management System)**에서 **통합보안이벤트관리(SIEM, Security Information and Event Management)** 시스템으로 확장되었습니다. 여러 네트워크 장비의 로그를 통합 수집하고, 이를 분석하여 이상 징후를 탐지하는 시스템입니다.

통합보안이벤트관리 시스템의 핵심 목표는 상관분석을 통해 이상징후를 탐지하는 것이었지만, 자동 차단이라는 정보보안의 요구에 맞춰 **보안운영자동화(SOAR, Security Orchestration, Automation and Response)** 시스템을 추가하여 연동하는 방안이 제안되고 있습니다.

![2020_SIEM_SOAR_EDR-600x308](https://github.com/user-attachments/assets/17984ce3-656e-4246-921a-ae7805051552)

이러한 개념을 바탕으로 2020년대에는 "모든 것을 의심하라"는 **제로 트러스트 아키텍처(ZTA, Zero Trust Architecture)**가 새롭게 제안되고 있습니다.

![blog_20230516-1-600x358](https://github.com/user-attachments/assets/06786ccb-3895-4a9d-a4ae-9171feaf23d1)

**PLURA-XDR**은 이러한 대응 방식을 통합하여 각 제품을 수직적으로 제공하는 플랫폼입니다.

### 프루라의 문제 의식:
- 침입차단시스템(IPS), 침입탐지시스템(IDS), 네트워크탐지와대응(NDR) 등 네트워크 기반 정보보안 제품은 암호화된 패킷 분석에 있어 제한적입니다. 대부분의 패킷은 웹패킷(HTTP/HTTPS)으로, 웹방화벽이 이를 가장 효과적으로 분석할 수 있습니다.
- 웹방화벽은 우회 공격에 취약할 수 있으며, 크리덴셜 스터핑 공격에 대응하지 못합니다.
- 통합보안이벤트관리(SIEM) 시스템은 정보 부족으로 탐지의 신뢰성을 확보하기 어려우며, 연동된 보안운영자동화(SOAR)가 실제 환경에서 동작하기 어렵습니다.

**PLURA-XDR**은 이러한 문제를 해결하기 위해 각 제품을 수직적으로 통합한 정보 보안 플랫폼을 제공합니다.

### 수직 통합 플랫폼의 가치:
- 웹방화벽(WAF)은 암호화된 패킷을 복호화하여 대응
- 호스트보안(EDR)은 해커가 도착하는 서버와 PC에서 악성 행위 대응
- 통합보안이벤트(SIEM) 솔루션은 정확한 탐지 정보 제공
- 보안운영자동화(SOAR)는 크리덴셜 스터핑과 같은 공격을 탐지하고 차단

### 정보보안과 보안관제:
정보보안의 문제는 솔루션 선택뿐만 아니라 **보안관제(MSS, Managed Security Service)**의 필요성에서도 나타납니다. 하지만 현재 보안관제는 제한된 서비스만 제공하고 있습니다.

### PLURA-XDR 플랫폼의 변화:
- 상세 탐지 설명과 원본 로그 제공으로 공격 여부 판단
- 운영 시스템에 접근하지 않고 침해사고 분석
- 실시간 공격 확인 후 차단 수행
- 공격에 대한 가시성과 컨텍스트 제공으로 대응 주도

### 책임감 있는 서비스:
> **웹 공격 대응 실패 시 서비스 비용을 환불해 드립니다.**

### 참고 사이트:
[1] IPS와 NDR 차이와 한계 with ChatGPT, [http://blog.plura.io/?p=18953](http://blog.plura.io/?p=18953)  
[2] 웹방화벽 우회 공격 어떻게 대응할 수 있을까요?, [http://blog.plura.io/?p=19174](http://blog.plura.io/?p=19174)  
[3] 크리덴셜 스터핑 공격 대응하기 with ChatGPT, [http://blog.plura.io/?p=18955](http://blog.plura.io/?p=18955)  
[4] Splunk 에서 요청 본문(request body) 로그 분석하기 with ChatGPT, [http://blog.plura.io/?p=18910](http://blog.plura.io/?p=18910)  
[5] WAF vs IPS vs UTM 비교하여 웹 공격 최상의 제품 선택하기 with ChatGPT, [http://blog.plura.io/?p=19190](http://blog.plura.io/?p=19190)
