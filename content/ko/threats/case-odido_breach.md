---
title: "Odido 620만 고객정보 유출: 피싱·IT지원 사칭으로 CRM를 뚫은 소셜공학 공격"
date: 2026-02-24
draft: false
description: "네덜란드 통신사 Odido가 피싱 이메일과 IT지원 사칭 전화(vishing)로 직원 계정이 탈취되어 고객 연락처/CRM 시스템에서 620만 명 규모 개인정보가 유출된 사건을 공격 단계별로 정리하고, PLURA-EDR·PLURA-XDR 관점의 탐지/대응 포인트를 제시합니다."
featured_image: "cdn/threats/case-odido_breach.png"
tags: ["Odido", "Data Breach", "Phishing", "Social Engineering", "Vishing", "CRM", "Salesforce", "Telecom", "개인정보 유출", "PLURA-EDR", "PLURA-XDR", "XDR", "EDR"]
---

네덜란드 통신사 **Odido**에서 **약 620만 명(6.2M)** 규모의 고객 정보가 유출된 것으로 알려졌습니다.  
공격은 전형적인 **소셜 엔지니어링(피싱 + IT지원 사칭 전화)**로 시작해, 직원 계정 탈취 후 **고객 연락처/CRM 시스템에서 대량 다운로드(스크래핑/수집)**로 이어졌습니다. :contentReference[oaicite:1]{index=1}

유출 정보에는 고객의 **이름, 주소, 휴대전화번호, 이메일, 고객번호, IBAN(계좌번호), 생년월일, 여권/운전면허 등 신분증 식별정보 및 유효기간** 등이 포함될 수 있다고 안내되었습니다. 반면 **‘Mijn Odido’ 비밀번호, 통화내역, 위치정보, 청구/인보이스 정보, 신분증 스캔본** 등은 포함되지 않았다고 공지되었습니다. :contentReference[oaicite:2]{index=2}

![Odido 데이터 유출 케이스](https://blog.plura.io/cdn/threats/case-odido_breach.png)

<!--more-->
---

### 1. **정찰 (Reconnaissance)**
#### 🔍 **“사람”과 “업무 흐름”을 먼저 본다**
- 공격자는 고객센터/CS 조직을 노려 **직원 로그인 정보**를 얻는 전략을 선택합니다. (CS는 계정 접근 권한이 넓고, 업무상 외부 연락에 익숙해 표적이 되기 쉽습니다.) :contentReference[oaicite:3]{index=3}
- Odido는 고객 대응을 위한 **고객 연락처/CRM 시스템**을 운영하고 있었고, 공격자는 이 지점을 “대량 수집”의 최종 목표로 삼습니다. :contentReference[oaicite:4]{index=4}
- (보도에 따르면) 공격자는 Odido의 **Salesforce 환경**에 접근한 정황이 언급됩니다. :contentReference[oaicite:5]{index=5}

---

### 2. **최초 침투 (Initial Access)**
#### 🚨 **피싱 이메일 + IT지원 사칭 전화(vishing)로 MFA를 우회**
- 공격자는 **직원에게 피싱 이메일**을 보내 로그인 정보를 입력하도록 유도합니다. :contentReference[oaicite:6]{index=6}
- 이후 다른 직원에게 **IT 부서 직원을 사칭해 전화**하고, “로그인 시도 승인”을 요청해 **추가 보안 단계(예: MFA 승인)**를 통과합니다. :contentReference[oaicite:7]{index=7}
- 현지 보도에서는 이 방식으로 **복수 직원 계정이 침해**되었다는 정황이 언급됩니다. :contentReference[oaicite:8]{index=8}

> ✅ 포인트  
> 이 단계는 기술적 취약점보다 **사람(신뢰)과 절차(승인)**를 공격합니다. 따라서 “악성코드”가 없거나 최소화될 수 있어, 전통적 시그니처 기반 방어만으로는 놓치기 쉽습니다.

---

### 3. **권한 악용 및 내부 접근 (Valid Accounts / Access)**
#### 🔑 **“정상 계정”으로 CRM에 들어가면, 공격이 ‘정상 업무’처럼 보이기 시작**
- 공격자는 탈취한 직원 계정으로 **고객 연락처/CRM 시스템에 접속**합니다. :contentReference[oaicite:9]{index=9}
- 피해 범위는 **Odido 고객(및 일부 자회사 고객)**에 걸친 것으로 보도되며, 일부 보도에서는 **최근 2년 내 해지한 전 고객**도 영향 가능성이 언급됩니다. :contentReference[oaicite:10]{index=10}

---

### 4. **정보 수집 (Collection)**
#### 🗄️ **CRM에서 ‘필드 단위 개인정보’를 빠르게 긁어 모은다**
- 공격자는 CRM 내부의 고객 데이터를 **스크래핑/대량 조회·다운로드** 방식으로 수집한 것으로 알려졌습니다. :contentReference[oaicite:11]{index=11}
- 유출 가능 정보(안내 기준)
  - 이름, 주소/거주도시, 휴대전화번호, 이메일, 고객번호  
  - IBAN(계좌번호), 생년월일  
  - 여권/운전면허 등 신분증 식별정보 및 유효기간 :contentReference[oaicite:12]{index=12}

---

### 5. **정보 유출 (Exfiltration)**
#### 📤 **대량 유출인데도 ‘합법 트래픽’처럼 빠져나갈 수 있다**
- 이 사건은 랜섬웨어처럼 서비스 중단이 동반된 정황이 아니라, **고객 연락처 시스템에서 데이터가 다운로드**된 형태로 알려졌습니다. :contentReference[oaicite:13]{index=13}
- 일부 보도에서는 공격자가 **회사에 연락해 “수백만 건을 탈취했다”고 주장**했고, 그 뒤 대응이 진행된 정황이 언급됩니다. 즉 “내부에서 먼저 잡았다기보다, 이미 가져간 뒤에 확인된” 그림이 될 수 있습니다. :contentReference[oaicite:14]{index=14}

---

### 6. **유출 방법 개념도 (시나리오)**
```mermaid
sequenceDiagram
    participant Attacker as 공격자
    participant CS as 고객센터 직원(피해자)
    participant IT as (사칭) IT지원
    participant MFA as MFA/추가 승인
    participant CRM as 고객 연락처/CRM 시스템(SaaS)
    participant SOC as 보안/대응팀

    Note over Attacker, CS: 1) 피싱으로 자격증명 탈취
    Attacker->>CS: 피싱 이메일(가짜 로그인 페이지)
    CS->>Attacker: ID/PW 입력(탈취)

    Note over Attacker, IT: 2) IT지원 사칭 전화로 승인 유도
    Attacker->>CS: 전화(IT지원 사칭) "로그인 승인 필요"
    CS->>MFA: 푸시/코드 승인(추가 보안 우회)

    Note over Attacker, CRM: 3) 정상 계정으로 CRM 접속 후 스크래핑
    Attacker->>CRM: 직원 계정으로 로그인
    Attacker->>CRM: 대량 조회/다운로드(스크래핑)
    CRM-->>Attacker: 고객 개인정보(6.2M 규모)

    Note over SOC: 4) 이상징후 탐지/신고 후 차단 및 조사
    SOC->>CRM: 세션 종료/접근 차단
    SOC->>SOC: 영향 범위·로그 포렌식·재발방지
