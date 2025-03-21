---
date: 2023-02-19T01:00:00
draft: false
title: "샤오치잉(Xiaoqiying) 해킹 공격 대응하기"
description: 
featured_image: "cdn/respond/xiaoqiying-hacking-attack-1.png"
tags: ["Xiaoqiying", "PLURA-WAF", "웹 방화벽", "웹 해킹", "공격 대응", "크리덴셜 스터핑"]
---

## 🏗️개요

해킹 그룹 **샤오치잉(Xiaoqiying)** 은 18개 공공 기관 및 기업에 해킹 공격을 가했다고 주장하고 있습니다.  
이번 공격 사례를 정리한 결과, 주요 경로는 **웹 서버**를 통한 공격이었습니다.
<!--more-->
![xiaoqiying-hacking-attack](https://blog.plura.io/cdn/respond/xiaoqiying-hacking-attack-1.png)

---

## 💥주요 피해 경로

샤오치잉 공격의 결과로 피해 기관의 홈페이지가 위변조되었으며, 첫 페이지가 해당 해킹 그룹의 로고로 변경되었습니다.  
이후 추가적인 해킹 공격으로 발전할 가능성이 있으며, 대표적인 사례는 다음과 같습니다:

1. **랜섬웨어 공격**으로 시스템 파괴.  
2. 홈페이지를 통해 데이터베이스에 접근하여 **고객 정보와 기밀 정보 유출.**  
3. **백도어 설치** 후 내부 다른 시스템으로 **APT(지능형 지속 공격)** 수행.  
4. **백도어를 숨겨 다른 기업을 공격**하는 서버로 활용.

> 여러 보안 보고서에 따르면, 해킹 공격의 80%는 웹 서버를 통해 시작되며,  
> 랜섬웨어 공격의 70% 역시 웹 서버를 경유하여 진행됩니다.

---

## 🛠️웹 해킹 대응 방법

### 1. 웹 방화벽(WAF)의 필요성
웹 서버 공격을 방어하기 위해 **웹 방화벽(WAF, Web Application Firewall)** 은 필수적입니다.

---

### 2. 웹 방화벽 관리의 어려움

웹 방화벽은 효과적이지만 다음과 같은 관리가 필요합니다:
- **패턴 관리**: 지속적으로 새롭게 등장하는 공격 패턴에 맞춰 업데이트해야 합니다.  
- **웹 로그 분석**: 웹 방화벽에서 차단하지 못한 공격을 식별하기 위해 로그를 분석해야 합니다.  
- **크리덴셜 스터핑**: 계정 탈취 공격에는 웹 방화벽만으로 대응할 수 없습니다.

---

## 웹 방화벽(WAF)의 한계와 대안

### WAF의 구조적 한계
웹 방화벽은 단일 세션 기반으로 공격 여부를 판단합니다.  
따라서 공격을 탐지하지 못한 경우, 웹 서버로 그대로 전달됩니다.  

**대안:**  
웹 서버의 로그를 분석하여 해킹 공격 코드가 남아 있는지 확인하는 것이  
웹 방화벽을 우회한 공격에 대응할 수 있는 유일한 방법입니다.

---

### 침입 차단 시스템(IPS)의 비효율성
**침입 차단 시스템(IPS, Intrusion Prevention System)** 이 웹 패킷 분석에 적합하다는 주장이 있지만, 실환경에서 불가능합니다.  
- IPS는 웹 방화벽(WAF)에 비해 탐지 규칙의 수가 적어, 웹 방화벽이 놓친 공격을 탐지하기 어렵습니다.  

**비유:**  
> 웹 방화벽(WAF)은 프로 리그 골키퍼,  
> 침입 차단 시스템(IPS)은 유소년 리그 골키퍼와 같습니다.

---

## PLURA의 웹 해킹 대응 시스템

### PLURA의 장점
1. **PLURA-WAF**: 자체 웹 방화벽으로 웹 공격을 실시간 차단.  
2. **PLURA-SIEM**: 통계적 이상 징후 탐지로 **크리덴셜 스터핑 공격**에 대응.  
3. **웹 헤더 및 본문 정보 분석**: 전체 웹 로그를 활용해 **알려지지 않은 공격**에 대응.

---

## 📖 함께 읽기

- [크리덴셜 스터핑 대응하기](https://blog.plura.io/ko/respond/credential-stuffing-countermeasures/)  
- [PLURA-WAF 데모](https://youtu.be/sDssT98NCg0?si=EbAiClNRxZQXflQg)  
- [PLURA-WAF 사용 가이드](https://docs.plura.io/ko/fn/waf)  
- [PLURA-SIEM 사용 가이드](https://docs.plura.io/ko/fn/comm)
