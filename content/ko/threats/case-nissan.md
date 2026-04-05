---
title: "닛산 오세아니아 해킹 사건: Akira 랜섬웨어의 금융·신분증 정보 탈취와 10만 명 피해"
date: 2026-04-05
draft: false
description: "2023년 12월 발생한 닛산 오세아니아 해킹 사건을 정리합니다. Akira 랜섬웨어가 닛산 호주·뉴질랜드 IT 서버에 무단 접근해 데이터를 탈취하고 다크웹에 공개한 사건으로, 약 10만 명 규모의 고객·직원·딜러 정보가 영향을 받았습니다. 금융 서비스 정보와 신분증 정보까지 포함된 점에서 자동차 제조업과 금융 서비스가 결합된 구조의 위험을 보여준 대표 사례입니다."
featured_image: "cdn/threats/case-nissan-oceania-akira.png"
tags: ["Nissan", "닛산", "Akira", "랜섬웨어", "금융정보 유출", "신분증 유출", "자동차 제조업 보안", "Nissan Financial Services", "PLURA-XDR", "PLURA-EDR", "PLURA-WAF", "Double Extortion"]
---

자동차 제조업을 겨냥한 사이버 공격은 이제 더 이상  
생산 설비나 설계 문서에만 머물지 않습니다.

이번 **닛산 오세아니아(Nissan Oceania) 해킹 사건**은  
자동차 제조사 본체와 함께, 그 계열 금융 서비스까지 동시에 타격할 경우  
어떤 규모의 개인정보·금융정보 침해가 발생할 수 있는지를 보여준 대표 사례입니다.

2023년 12월 5일, 닛산은 호주·뉴질랜드 IT 서버에 대한 무단 접근 사고를 확인했고,  
이후 조사 결과 일부 고객·직원·딜러·기타 이해관계자의 개인정보가 탈취되어  
다크웹에 게시된 사실을 공지했습니다. 닛산은 2024년 3월부터 약 **10만 명** 규모의 영향권 대상자에게 통지를 시작했습니다. 

<!--more-->

---

## 핵심 요약

- **사건 발생일:** 닛산은 **2023년 12월 5일** 호주·뉴질랜드 IT 서버에 대한 무단 접근 사고를 확인했습니다. 
- **피해 기업:** 닛산 오세아니아로, **Nissan Australia, Nissan New Zealand, Nissan Financial Services Australia, Nissan Financial Services New Zealand** 등이 포함됐습니다. 
- **공격 주체:** 공식 공지에서는 공격자를 특정하지 않았지만, 보안 언론과 업계에서는 **Akira 랜섬웨어**의 소행으로 널리 보도됐습니다. 
- **피해 규모:** 닛산은 약 **10만 명**이 영향을 받았다고 통지했고, NSW 정부도 같은 규모로 안내했습니다. 
- **핵심 유출 데이터:** 이름, 연락처, 생년월일, 신분증 사본과 번호, 세금식별번호, 금융정보, 자동차 대출 정보, 고용정보 등 폭넓은 개인정보가 포함됐습니다. 
- **중요 포인트:** 이 사건은 단순 제조업 침해가 아니라, **자동차 판매·정비·금융·보험 업무가 결합된 데이터 구조**가 한 번에 노출될 수 있다는 점에서 특히 위험합니다. 

---

## 사실 관계 정리

### ✅ 공개적으로 확인된 내용

- 닛산은 **2023년 12월 5일**, 악성 제3자가 닛산의 호주·뉴질랜드 IT 서버에 **무단 접근**한 사이버 사고가 발생했다고 공식 공지했습니다. 
- 닛산은 조사 결과, 일부 고객·직원·기타 이해관계자의 개인정보가 **탈취되어 다크웹에 게시**됐다고 밝혔습니다. 
- 공지 대상은 닛산 브랜드만이 아니라, **Nissan Financial Services, Mitsubishi Motors Financial Services, Renault Financial Services, Infiniti Financial Services, Skyline Car Finance/Insurance** 등 관련 금융·보험 브랜드 이용자까지 포함될 수 있다고 안내했습니다. 
- 닛산은 호주 및 뉴질랜드의 영향권 대상자에게 개별 통지를 시작했고, 일부는 연락처 부재 등으로 공지문을 통해 알렸습니다. 
### 🟨 외부 보도 및 기관 안내로 확인되는 내용

- NSW 정부는 이번 사건 영향 규모를 약 **10만 명**으로 안내했습니다.
- NSW 정부 안내에 따르면 유출 데이터셋에는 약 **운전면허증 7,500건**, **메디케어 카드 4,000건**, **여권 220건**, **세금파일번호(TFN) 1,300건**이 포함됐고, 약 **10%**는 핵심 신분증 정보가 포함된 것으로 정리됐습니다. 
- 보안 언론은 닛산 사건을 **Akira 랜섬웨어**와 연결해 보도했고, 공격자는 약 **100GB** 데이터 탈취를 주장한 것으로 알려졌습니다. 다만 이 수치는 해커 측 주장으로 봐야 합니다. 

### 🗓️ 타임라인

- **2023-12-05:** 닛산 오세아니아 IT 서버 무단 접근 사고 발생 및 대응 개시 
- **2023-12월 중순:** 외부 보도 기준으로 Akira가 닷웹 유출 사이트에서 닛산 사건을 주장하고 공개 압박 시작 
- **2024-03-13:** 닛산이 조사 결과를 바탕으로 영향권 대상자 통지 개시 
- **2024-03-15 전후:** 호주 정부 기관과 언론이 약 10만 명 영향 사실을 공개 안내
- **2024-04-15:** 닛산 대응 콜센터 운영사 OracleCMS에서 별도 데이터 유출이 발생해 일부 피해자 정보가 다시 노출되는 2차 사고가 발생했습니다. 

---

## 1. 사건 개요

### 🚗 자동차 제조업 해킹이 금융 피해로 확대되는 구조

이 사건이 특히 중요한 이유는  
닛산이 단순 자동차 제조사만이 아니라,  
차량 판매·할부·보험·고객지원·딜러 네트워크를 함께 운영하는 구조를 갖고 있기 때문입니다.

즉, 한 번의 침해로 다음 데이터가 함께 엮여 노출될 수 있습니다.

- 차량 구매 및 금융 계약 정보
- 고객 신원확인 문서
- 대출·상환 이력
- 직원 고용 및 급여 정보
- 딜러 및 파트너 관련 자료
- 각종 지원·보험·계약 문서

이 때문에 자동차 제조업 대상 공격은  
단순 생산 차질이 아니라  
**금융사 수준의 개인정보 유출 사고**로 번질 수 있습니다. 

---

## 2. 공격 방식

### 🚨 내부 서버 무단 접근 + 데이터 탈취 + 공개 협박

닛산 공식 공지는 “무단 접근”과 “정보 탈취 및 다크웹 게시”를 명확히 언급합니다.  
즉, 이번 사건도 전형적인 **이중 협박(Double Extortion)** 구조로 해석할 수 있습니다. 

공격 흐름은 다음처럼 볼 수 있습니다.

1. 호주·뉴질랜드 IT 서버에 비인가 접근  
2. 고객·직원·딜러·금융 관련 데이터 수집  
3. 데이터 외부 반출  
4. 협상 또는 압박 시도  
5. 몸값 미지급 또는 협상 실패 시 다크웹 공개

즉, 이 사건의 핵심은 단순 파일 암호화보다  
**개인정보와 금융정보를 빼낸 뒤 공개를 압박하는 갈취형 랜섬웨어 운영**에 있습니다. 
---

## 3. 초기 침투는 어떻게 이뤄졌을까

### 🔓 이번 사건의 정확한 최초 침투 경로는 공식 발표되지 않았다

닛산은 공식 공지에서  
**어떤 취약점이나 계정이 최초 침투에 사용됐는지 공개하지 않았습니다.** 

다만 Akira와 관련해 공개된 정부·벤더 자료를 보면,  
이 그룹은 다음과 같은 방식으로 기업 네트워크에 들어오는 사례가 반복적으로 관찰됐습니다.

- **MFA가 없거나 약한 VPN 계정 악용**
- **브루트포스 및 패스워드 스프레이**
- **탈취되거나 구매된 유효한 계정(Valid Accounts) 사용**
- **원격접속 인프라 취약점 악용**
- 침투 후 **LSASS 덤프**, 자격증명 탈취, LOLBins/COTS 도구 활용

Cisco는 2023년 Akira가 **MFA가 설정되지 않은 Cisco VPN 환경**을 노렸다고 공개했고,  
침해 후 자격증명 탈취와 추가 이동이 뒤따를 수 있다고 설명했습니다. FBI/CISA도 Akira가 2023년 3월 이후 광범위한 조직을 노렸다고 경고했습니다. 

따라서 닛산 사건도  
정확한 경로는 미확정이지만,  
**외부 노출 원격접속 지점 또는 유효한 계정 악용 가능성**을 열어두고 보는 것이 합리적입니다.

---

## 4. 어떤 데이터가 문제인가

### 🪪 이 사건은 ‘고객 정보 유출’이 아니라 ‘신원 도용 가능 정보 유출’ 사건이다

닛산 공지에 따르면 영향 데이터는 매우 광범위합니다.  
모든 피해자에게 동일하게 적용되지는 않지만, 다음과 같은 정보가 포함될 수 있습니다. 

- 이름
- 주소, 전화번호, 이메일
- 생년월일
- 운전면허증, 메디케어 카드, 여권, 비자, 출생증명서 등 **신분증 사본 및 번호**
- 호주 TFN 또는 뉴질랜드 IRD 번호
- 건강·의료·경찰조회·종교·노조 관련 **민감정보**
- 신용 관련 정보
- 은행 계좌·카드 등 금융정보
- 차량 등록 정보
- 자동차 대출 거래 및 상환 이력
- 고용계약, 급여, 평가, 퇴직 관련 자료
- 보험 및 연금 관련 정보

즉, 단순 연락처 유출이 아니라  
**신원 도용, 금융사기, 세금 사기, 대출 사기, 표적 피싱**으로 직결될 수 있는 정보가 함께 노출된 사건입니다.
---

## 5. 닛산 사건에서 특히 위험한 점

### 💳 자동차 제조사인데 왜 금융 보안 사고가 되었는가

이 사건은 제조사 침해가  
곧바로 **금융 서비스 침해**로 이어질 수 있음을 보여줍니다.

닛산은 공지문에서 다양한 금융·보험 브랜드를 직접 언급하며,  
닛산 브랜드 차량을 구매하지 않았더라도  
관련 금융·보험 서비스 이용 이력이 있다면 영향권일 수 있다고 설명했습니다. 

이 구조에서 가장 큰 리스크는 다음과 같습니다.

- **신분증 + 금융정보 결합 유출**
  - 단순 피싱이 아니라 실제 금융 사기로 이어질 수 있음
- **대출 및 상환 정보 노출**
  - 표적형 사기, 사회공학, 신용 사기 가능성 증가
- **직원·딜러 정보 동시 노출**
  - 내부자 사칭, 공급망 사칭, 후속 침해 가능성 확대
- **차량·고객·금융 데이터의 상호 연결**
  - 단일 정보보다 훨씬 높은 가치의 공격 데이터셋 형성

즉, 이 사건은  
자동차 산업이 이미 **제조업 + 금융업 + 서비스업이 결합된 데이터 산업**이라는 점을 잘 보여줍니다.
---

## 6. 공격 주체: Akira란 누구인가

Akira는 2023년 3월경부터 관찰된 랜섬웨어 그룹으로,  
기업과 중요 인프라 조직을 상대로 활동해 왔습니다. FBI/CISA는 Akira가 북미·유럽·호주 전반의 다양한 산업을 공격했다고 설명했습니다. 

공개 자료 기준으로 Akira는 다음 특징을 보입니다.

- 초기 접근 후 **데이터 탈취 + 암호화** 병행
- **VPN 및 원격접속 환경** 노림
- **MFA 미구성 환경** 선호
- **유효한 계정 악용** 및 자격증명 탈취
- 협상 실패 시 **다크웹 유출 사이트 공개 압박**

따라서 닛산 사건도  
단발성 예외가 아니라,  
Akira가 제조·교육·중소기업·중요 인프라 등에서 반복해 온  
전형적 갈취형 랜섬웨어 운영 패턴의 일부로 볼 수 있습니다. 

---

## 7. 이 사건에서 더 봐야 할 부분: 2차 피해

### 📞 사고 대응 과정에서도 다시 유출될 수 있다

닛산 사건은 여기서 끝나지 않았습니다.

닛산은 사고 대응을 위해 외부 콜센터 운영사 **OracleCMS** 를 활용했는데,  
이 운영사도 별도 데이터 유출 사고를 겪으면서  
닛산이 제공한 일부 요약 정보가 다시 다크웹에 게시됐다고 공지했습니다. 
이 점은 매우 중요합니다.

보안 사고 이후에는 보통
- 콜센터
- 통지 대행사
- 신용 모니터링 업체
- 법률·포렌식 지원사
- 외부 대응 플랫폼

같은 제3자 협력사가 대거 개입합니다.

즉, 사고 이후의 대응 체계가 복잡할수록  
**2차 유출, 2차 노출, 2차 사칭 공격** 가능성도 커집니다.  
닛산 사건은 이 점까지 보여준 드문 사례입니다. 
---

## 8. 공격 흐름 개념도

```mermaid
sequenceDiagram
    participant Attacker as 공격자(Akira 추정)
    participant Access as VPN/원격접속/유효 계정
    participant Server as Nissan Oceania IT 서버
    participant Data as 고객·직원·금융 데이터
    participant DLS as 다크웹 유출 사이트
    participant Vendor as OracleCMS 등 외부 대응사
    participant SOC as 보안 대응팀

    Note over Attacker, Access: 1) 초기 접근 확보
    Attacker->>Access: 계정 탈취 / VPN / MFA 미구성 지점 노림

    Note over Access, Server: 2) 내부 진입
    Access->>Server: 비인가 접근 및 내부 탐색

    Note over Server, Data: 3) 핵심 데이터 수집
    Server->>Data: 고객·금융·직원 정보 선별
    Data->>Attacker: 외부 반출

    Note over Attacker, DLS: 4) 공개 압박
    Attacker->>DLS: 피해 주장 및 데이터 공개

    Note over SOC, Vendor: 5) 사고 대응
    SOC->>Vendor: 통지/콜센터 운영 위탁
    Vendor-->>SOC: 일부 대응 정보 처리

    Note over Vendor: 6) 2차 사고 위험
    Vendor->>DLS: 별도 유출 시 요약 정보 재노출 가능
```

---

# PLURA 관점 정리

## 9. PLURA-EDR 관점: 이 사건의 핵심은 ‘누가 어떤 문서와 계정을 다뤘는가’입니다

닛산 사건처럼 제조업과 금융 서비스가 결합된 환경에서는  
악성코드 이름만 알아서는 충분하지 않습니다.

핵심은 다음입니다.

1. **어떤 계정이**
2. **어느 서버에 들어갔고**
3. **어떤 고객·금융 파일에 접근했으며**
4. **무엇을 압축하고 외부로 내보냈는지**
5. **그 과정에서 권한 상승이나 원격 실행이 있었는지**

PLURA-EDR 관점에서는 다음 추적이 중요합니다.

* 대량 파일 접근 및 압축 흔적
* 신분증 사본·대출 관련 문서·고용 문서의 비정상 조회
* LSASS 덤프 및 자격증명 탈취 정황
* 원격접속 후 내부 확산 행위
* 딜러·직원·금융업무 서버 간 비정상 이동
* 외부 반출 직전의 파일 생성·이동·아카이브 흔적

즉, 이런 사건의 핵심은  
**“랜섬웨어가 왔다”가 아니라 “어떤 데이터가 어떻게 빠져나갔는가”를 증거로 남기는 것**입니다.

---

## 10. PLURA-WAF / XDR 관점: 자동차·금융 통합 서비스는 데이터 유출을 실시간으로 봐야 합니다

이 사건처럼 고객지원, 금융 조회, 대출 문서, 계약 자료가  
웹 기반 업무 시스템이나 내부 포털을 통해 오가는 구조에서는  
대량 유출이 “정상 다운로드”처럼 보일 수 있습니다.

따라서 대응 포인트는 분명합니다.

* 웹 응답 기반 **대량 문서 전달** 탐지
* **Resp-body / Resp-size** 기반 이상 탐지
* 정상 계정처럼 보이는 세션의 **행위량·빈도·패턴 변화** 분석
* 금융·고객·직원 데이터 접근의 **상관 분석**
* 단일 이벤트가 아니라 **로그인 → 조회 → 압축 → 반출** 전체 흐름 연결

결국 이런 사건은  
**로그를 남기고, 전수 분석하고, 유출 징후를 상관 분석하는 체계**가 없으면 늦게 알 수밖에 없습니다.

---

## 11. 탐지 포인트 비교: EDR vs WAF/XDR

| 구분                | 무엇을 보나                   | 이 사건에서의 핵심 포인트                |
| ----------------- | ------------------------ | ----------------------------- |
| **PLURA-EDR**     | 계정, 프로세스, 파일, 압축, 원격 실행  | 누가 어떤 고객·금융 문서를 열고 복사했는지 확인   |
| **PLURA-EDR**     | 자격증명 탈취, 권한 상승, 내부 이동    | VPN 진입 후 내부 확산 여부 추적          |
| **PLURA-EDR**     | ZIP/7z/RAR 생성 및 반출 직전 흔적 | 유출 준비 단계 포착                   |
| **PLURA-WAF/XDR** | 요청/응답 본문, 다운로드 패턴        | 고객·금융 데이터 대량 조회 탐지            |
| **PLURA-WAF/XDR** | 응답 크기, 세션 빈도, 행위량        | 정상 사용자처럼 보이는 대량 추출 식별         |
| **PLURA-WAF/XDR** | 로그인-조회-반출 상관 분석          | “정상 계정 + 비정상 유출” 구조를 실시간으로 파악 |

---

## 12. 기타 주요 닛산 보안 사고

### 🧩 2021년 북미 소스코드 노출 사고

닛산은 이번 오세아니아 사건 외에도  
2021년 북미 법인에서 **노출된 Git 서버** 때문에 약 **20GB 규모 소스코드**가 외부에 공개된 사고를 겪었습니다.

이때는 랜섬웨어가 아니라  
기본 관리자 계정(`admin/admin`)으로 보호된 Git 서버가 외부에 노출되면서  
모바일 앱, 내부 도구, 진단 시스템 관련 코드가 유출된 것으로 보도됐습니다. ([BleepingComputer][1])

이 사례는 닛산 관련 보안 이슈가  
단순 악성코드 감염이 아니라,

* 계정 관리
* 개발 인프라 노출
* 원격접속 보안
* 데이터 거버넌스

문제와도 연결돼 있음을 보여줍니다. ([BleepingComputer][1])

---

## 정리

닛산 오세아니아 사건은  
단순한 “자동차 회사 랜섬웨어 감염” 사건으로 보기 어렵습니다.

핵심은 다음 세 가지입니다.

1. **자동차 제조사 침해가 금융·보험·고객 데이터 침해로 직결될 수 있다는 점**
2. **신분증과 금융정보가 함께 노출되면 피해가 단순 개인정보 유출을 넘어선다는 점**
3. **사고 대응 과정의 외부 위탁 구조까지 2차 유출 위험이 될 수 있다는 점**

이제 자동차 산업 보안은  
생산망만 보는 수준으로는 부족합니다.

어떤 계정이 로그인했는지,  
어떤 문서가 열렸는지,  
어떤 신분증 파일이 복사됐는지,  
어떤 금융 데이터가 대량으로 나갔는지,

그 전 과정을 **기록하고 분석하고 대응할 수 있어야** 합니다.

그것이 바로  
자동차 제조업과 금융 서비스가 결합된 시대의 현실적인 보안 기준입니다.

---

## 업데이트 예정

이 사건은 닛산의 공식 통지와 2024년 공개 자료를 기준으로 정리한 것입니다.  
향후 다음 내용이 추가로 확인되면 본 글도 업데이트할 필요가 있습니다.

* 정확한 최초 침투 경로
* Akira와의 공식 연계 여부
* 암호화 피해 범위 및 운영 영향
* 추가 유출 데이터 범위
* 제3자 대응사 연계 2차 피해 확정 내용

---

## 참고 자료(출처)

* Nissan Australia / Nissan Financial Services Australia, `Notice: Cyber security incident impacting Nissan Australia and New Zealand` ([Nissan Australia][2])
* ID Support NSW, `Nissan Motor Corporation and Nissan Financial Services data breach` ([NSW Government][3])
* The Register, `Nissan Oceania to alert 100K people affected by cyberattack` ([더레지스터][4])
* Dark Reading, `Nissan Oceania breached; 100K customers, employees, dealers affected` ([Dark Reading][5])
* Cisco, `Akira Ransomware Targeting VPNs without Multi-Factor Authentication` ([Cisco Blogs][6])
* FBI / CISA, `#StopRansomware: Akira Ransomware` 및 관련 공식 경고 목록 ([CISA][7])
* BleepingComputer, `Nissan NA source code leaked due to default admin:admin credentials` ([BleepingComputer][1])

---

[1]: https://www.bleepingcomputer.com/news/security/nissan-na-source-code-leaked-due-to-default-admin-admin-credentials/?utm_source=chatgpt.com "Nissan NA source code leaked due to default admin ..."
[2]: https://www.nissan.com.au/content/dam/Nissan/AU/Files/notice/Notice-%20Cyber%20security%20incident%20impacting%20Nissan%20Australia%20and%20New%20Zealand.pdf?utm_source=chatgpt.com "Notice- Cyber security incident impacting ..."
[3]: https://www.nsw.gov.au/departments-and-agencies/id-support-nsw/learn/data-breaches/data-breach-announcements/nissan-data-breach?utm_source=chatgpt.com "Nissan Motor Corporation and Nissan Financial Services ..."
[4]: https://www.theregister.com/2024/03/14/nissan_oceania_100k_affected/?utm_source=chatgpt.com "Nissan Oceania to alert 100K people affected by cyberattack"
[5]: https://www.darkreading.com/cyberattacks-data-breaches/nissan-oceania-breached-100k-customers-employees-dealers-affected?utm_source=chatgpt.com "Nissan Oceania Breached; 100K People Affected Down ..."
[6]: https://blogs.cisco.com/security/akira-ransomware-targeting-vpns-without-multi-factor-authentication?utm_source=chatgpt.com "Akira Ransomware Targeting VPNs without Multi-Factor ..."
[7]: https://www.cisa.gov/stopransomware/official-alerts-statements-fbi?utm_source=chatgpt.com "Official Alerts & Statements - FBI"
