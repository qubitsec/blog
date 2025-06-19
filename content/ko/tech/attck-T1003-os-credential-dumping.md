---
title: "RAM 안의 비밀번호를 노린다 – T1003.004: LSASS Memory Credential Dumping"
date: 2025-06-20
draft: false
description: "LSASS 메모리를 덤프해 윈도우 사용자 인증 정보를 훔치는 기술은 고급 침투 공격자의 대표적인 수법입니다. MITRE ATT&CK의 T1003.004 기술을 중심으로, 메모리 내 자격 증명 탈취 방법과 이를 탐지·차단하는 보안 전략을 소개합니다."
featured_image: "cdn/threats/t1003-lsass-memory.png"
tags: ["MITRE ATT&CK", "T1003.004", "LSASS", "Credential Dumping", "RAM 공격", "침투탐지", "EDR", "PLURA-XDR", "사이버보안"]
---

## 🔎 관련 MITRE ATT\&CK 기법

### 🧠 T1003.004 – *OS Credential Dumping: LSASS Memory*

* 공격자는 RAM 내 **LSASS 프로세스 메모리**에서 자격 증명(패스워드 해시 등)을 추출합니다.
* 절전 직전 메모리 접근과 유사한 기술로, **물리적 메모리 접근 시도** 또는 메모리 덤프 분석과 관련 있음.

### 💾 T1486 – *Data Encrypted for Impact*

* 이는 **전통적인 랜섬웨어 암호화 행위**를 대표하는 기법입니다.
* **디스크, 네트워크, 외부 장치, 메모리 상 데이터 등 모든 접근 가능한 정보 자산을 암호화**하는 형태로 확장되고 있습니다.
* 일부 고급 랜섬웨어는 메모리 영역에 남은 정보를 대상으로 암호화 작업을 수행하거나,
  **재부팅 또는 복구 시 자동 실행을 위한 정보를 메모리 상에 삽입**합니다.

---

## 📌 악성코드 예시 (실제 사례 기반)

### 1. **HermeticWiper** (2022, 우크라이나 공격)

* 디스크 파괴 전에 **메모리와 시스템 복구 영역에 흔적을 남겨 복원 차단**
  (출처: [Symantec Threat Intelligence](https://symantec-enterprise-blogs.security.com/blogs/threat-intelligence/hermeticwiper-ukraine-russia))

### 2. **NotPetya** (2017)

* MBR 변조와 함께 **메모리 기반에서 복구 불가능하게 시스템 작동 구조를 파괴**
  (출처: [MITRE ATT\&CK – NotPetya](https://attack.mitre.org/software/S0368/))

### 3. **LockerGoga**

* 감염 즉시 암호화를 실행하며, 메모리에 상주한 데이터를 포함한 빠른 암호화로 분석 및 복구를 방해
  (출처: [CERT-FR LockerGoga](https://www.cert.ssi.gouv.fr/cti/CERTFR-2019-CTI-001/))

---

## 🔖 출처

- MITRE ATT&CK Technique: [T1486 – Data Encrypted for Impact](https://attack.mitre.org/techniques/T1486/)
- MITRE ATT&CK Technique: [T1003.004 – OS Credential Dumping: LSASS Memory](https://attack.mitre.org/techniques/T1003/004/)
- Symantec: [HermeticWiper targets Ukraine](https://symantec-enterprise-blogs.security.com/blogs/threat-intelligence/hermeticwiper-ukraine-russia)
- MITRE: [NotPetya Malware Profile](https://attack.mitre.org/software/S0368/)

---
