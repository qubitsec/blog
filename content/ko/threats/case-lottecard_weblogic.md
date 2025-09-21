---
title: "롯데카드 해킹 사고 분석 – 오래된 취약점 방치"
date: 2025-09-10
draft: false
description: "2025년 8월 롯데카드 온라인 결제 서버 해킹 사건을 타임라인과 기술적 세부, 다크웹 유출 여부, 금융당국 후속 조치까지 종합 정리합니다."
featured_image: "cdn/threats/case-lottecard_weblogic.png"
tags: ["롯데카드", "해킹", "데이터 유출", "웹셸", "Oracle WebLogic", "CVE-2017-10271", "금융보안", "침해사고"]
---

2025년 **8월 14일 19:21** 최초 침해가 발생했고, 8월 15일까지 활동이 이어지며 **내부 파일 유출(약 1.7GB)** 정황이 확인되었습니다. 8월 16일 추가 시도는 있었으나 추가 유출은 없던 것으로 전해졌습니다. **8월 26일** 서버 점검 중 악성코드를 발견했고, **8월 31일 정오** 온라인 결제 서버에서 외부 유출 시도가 공식 확인, **9월 1일** 금융감독원에 보고되었습니다. 금융당국은 현장검사와 소비자 보호 조치를 즉시 지시했습니다. ([KBS World][1])

> **핵심:** 공격자는 2017년에 공개·패치된 Oracle WebLogic 취약점(CVE-2017-10271)을 악용해 **웹 셸(Web shell)**을 심고 내부 서버 권한을 획득했습니다. 조사 과정에서 **3개 서버**에서 **2종의 악성코드와 5종의 웹 셸**이 발견되어 제거되었습니다. ([보안뉴스][2])

<!--more-->

![롯데카드 해킹 사건](https://blog.plura.io/cdn/threats/case-lottecard_weblogic.png)

---

### 1. **초기 침투 (Initial Access)**

#### 🔓 **오래된 WebLogic 취약점(CVE-2017-10271) 악용 *(MITRE: T1190, T1505.003)***

* 공격자는 WebLogic의 **RCE 취약점**을 통해 원격 명령을 실행하고 웹 셸을 업로드, 서버 제어권을 확보했습니다. 해당 취약점은 **2017년 10월 공개 및 패치**가 제공되었으나, 미적용으로 인해 낮은 난이도의 침투가 가능했습니다. ([보안뉴스][2])

---

### 2. **내부 이동 및 장악 (Lateral Movement)**

#### 🚨 **웹 셸 기반 권한 유지·확장**

* 정밀 점검에서 **3개 서버**에 **2종 악성코드 + 5종 웹 셸**이 확인되었으며, 이는 다중 백도어를 통한 **지속성(Persistence)** 확보 시도로 해석됩니다. ([전자부품 전문 미디어 디일렉][3])

---

### 3. **데이터 유출 시도 (Exfiltration Attempt)**

#### 📂 **약 1.7GB 전송 정황·핵심 개인정보 유출은 ‘미확인’**

* **1.7GB 규모**의 데이터 반출 정황이 확인되었고, 당국은 **온라인 거래 요청 정보** 등 민감 데이터 포함 가능성을 조사 중입니다. 다만 **고객의 핵심 개인정보 직접 유출은 현재까지 확인되지 않았다**는 입장이 유지되고 있습니다. ([KBS World][1])

---

### 4. **사고 인지 및 금융당국·회사 후속 조치**

* **9월 1일** 보고 접수 → **9월 2일** 금감원 **현장검사**. 금감원은 **전용 콜센터 운영**, **이상 거래 모니터링 강화**, **부정사용 전액 보상 절차 마련**, **카드 해지·재발급 안내 고지** 등을 지시했습니다. ([Korea Joongang Daily][4])
* **9월 3일** 롯데카드는 **24시간 상담 ARS** 신설·운영, 앱/웹에 **비밀번호 변경·해외거래 차단·재발급 링크**를 제공하는 등 고객 보호 조치를 발표했습니다. ([TV조선][5])
* **9월 4일** 대표이사 **대국민 사과** 및 **피해 시 전액 보상 약속**. ([Businesskorea][6])
* 회사 홈페이지에는 **개인정보 유출 가능성 안내**와 **사칭 스미싱 주의** 공지가 올라와 있습니다. ([롯데카드][7])

---

### 5. **공격 개념도**

```mermaid
sequenceDiagram
    participant 공격자
    participant WAS as WebLogic 서버
    participant 내부망 as 내부 시스템
    participant 외부 as 외부 전송

    Note over 공격자,WAS: 1) CVE-2017-10271 원격 코드 실행
    공격자->>WAS: 웹셸 업로드 (RCE)
    WAS-->>공격자: 서버 제어권 획득

    Note over WAS,내부망: 2) 권한 상승·지속성 확보(여러 웹셸)
    WAS->>내부망: 추가 명령 실행·이동

    Note over 내부망: 3) 데이터 반출 시도
    내부망-->>외부: 약 1.7GB 전송 정황
    Note over 외부: 4) 랜섬/협박 포스팅은 미확인(9/14 기준)
````

---

### 🛡️ 보안 시사점

| 점검 항목           | 설명                                                                              |
| --------------- | ------------------------------------------------------------------------------- |
| **패치 거버넌스**     | 수년 전 공개 취약점 악용 → **WAS/미들웨어 정기 패치·EoL 관리·취약점 SLAs** 필수. ([보안뉴스][2])             |
| **웹 셸 탐지/제거**   | **파일 무결성·명령 패턴·비정상 프로세스** 탐지와 **다중 웹 셸 일괄 제거 절차** 필요. ([전자부품 전문 미디어 디일렉][3])    |
| **Egress 모니터링** | **대용량 전송/비정상 외부 목적지** 탐지, **프록시·FW DLP 룰**로 반출 차단. (유출 1.7GB 정황) ([경향신문][9])    |
| **사고 커뮤니케이션**   | **현장검사 대응, 전용 콜센터, 전액 보상 프로세스** 등 고객 불안을 낮추는 즉시 조치. ([Korea Joongang Daily][4]) |
| **사칭 스미싱 대응**   | 공식 채널 고지 + **앱/웹 원클릭 보호 메뉴** 제공으로 2차 피해 예방. ([TV조선][5])                         |

---

## 부록 — CVE-2017-10271 (Oracle WebLogic WLS-WSAT) RCE: 개요·PoC·PLURA-WAF 차단 로그

CVE-2017-10271은 Oracle WebLogic Server의 **WLS WSAT(Web Services Atomic Transaction)** 컴포넌트에 존재하는 **원격 코드 실행(RCE)** 취약점입니다. 이 취약점은 매우 널리 악용되었으며, 다양한 랜섬웨어·크립토마이너 유포 캠페인에 활용된 바 있습니다.

### 📌 기본 정보

* **CVE ID:** CVE-2017-10271
* **취약점 종류:** `WorkContext` 헤더에서 **java.beans.XMLDecoder**를 이용한 **불안전 역직렬화(Deserialization) 기반 RCE**
* **CVSS v3 점수:** 9.8 (**Critical**)
* **영향 버전:**

  * WebLogic Server **10.3.6.0**
  * WebLogic Server **12.1.3.0**
  * WebLogic Server **12.2.1.0, 12.2.1.1, 12.2.1.2** 등
* **공격 난이도:** 낮음 (비인증 원격에서 공격 가능)
* **주요 경로:** `/wls-wsat/CoordinatorPortType`

### ⚙️ 취약점 동작 원리

* WLS WSAT 구성 요소는 SOAP 기반 웹 서비스 요청을 처리합니다.
* 취약한 버전은 SOAP XML 요청의 `work:WorkContext` 헤더에 포함된 객체를 **XMLDecoder로 역직렬화**합니다.
* 공격자는 여기에 **`java.lang.ProcessBuilder` 등 실행 객체를 포함한 XML**을 삽입해 서버 측에서 **임의 명령 실행**을 유도합니다.

> **핵심 문제:** `WorkContext` 헤더를 신뢰하고 **XMLDecoder로 역직렬화** → 원격 코드 실행

### 🧪 공격 예시 (PoC 구조)

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header>
    <work:WorkContext xmlns:work="http://bea.com/2004/06/soap/workarea/">
      <java version="1.8" class="java.beans.XMLDecoder">
        <object class="java.lang.ProcessBuilder">
          <array class="java.lang.String" length="3">
            <void index="0"><string>cmd</string></void>
            <void index="1"><string>/c</string></void>
            <void index="2"><string>calc.exe</string></void>
          </array>
          <void method="start"/>
        </object>
      </java>
    </work:WorkContext>
  </soapenv:Header>
  <soapenv:Body/>
</soapenv:Envelope>
```

* SOAP 요청의 헤더에 **악성 ProcessBuilder 객체** 삽입
* 대상 WebLogic 서버에 전송 → 서버에서 `calc.exe` 실행 (개념 증명)

### ⚠️ 영향 및 위험성

* **인증 필요 없음** → 외부 공격자가 직접 공격 가능
* **기본 포트:** 7001/tcp (HTTP), 7002/tcp (HTTPS)
* **다양한 공격에 악용됨:**

  * 랜섬웨어, 코인마이너 설치
  * 웹 셸 업로드 → **지속적 백도어**
  * 광범위한 자동화 스캐닝·공격 툴에 포함

### 🛡️ 대응 방안

* **보안 패치 적용:** Oracle Critical Patch Update (CPU) — **2017년 10월** 발표

  * 10.3.6.0 → **PSU 적용**
  * 12.1.3.0 이상 → **최신 버전으로 업그레이드**
* **임시 방어 조치:**

  * `/wls-wsat` 경로 **접근 차단** (예: WAF/방화벽)
  * WebLogic 서버 **외부 공개 차단**
  * **의심 트래픽 모니터링** (User-Agent, SOAP/XML POST 등)
* **적용 확인 체크리스트:** WebLogic **버전/패치레벨 확인** → **외부 노출(7001/7002) 점검** → **`/wls-wsat` 경로 차단(WAF/FW)** → **의심 SOAP/XML POST 탐지 룰 활성화**

테스트는 아래 exploit-db의 PoC 코드를 사용하여 진행했습니다.
[https://www.exploit-db.com/exploits/43458](https://www.exploit-db.com/exploits/43458)
*OffSec’s Exploit Database Archive*

> 취약한 버전의 Oracle 환경 구축에 다소 시간이 걸려, 우선 **기존 설치되어 있는 웹서버로 테스트**를 진행하여 **로그 확인 및 탐지/차단 유무**를 확인했습니다.

**PLURA-WAF 룰**에 따라 첨부 이미지와 같이 **탐지/차단**되었습니다.

![PLURA-WAF 406 차단 로그 #1](cdn/threats/weblogic-wls-wsat-detect-1.png)
![PLURA-WAF 406 차단 로그 #2](cdn/threats/weblogic-wls-wsat-detect-2.png)

---

### 🌟 PLURA-XDR의 보안 대응 방안

* **웹 셸 업로드/실행 실시간 탐지·자동 차단** — 공개 웹서비스 취약점 악용·웹 셸 업로드/명령 실행을 포착하면 WAF/EDR 연동으로 즉시 차단·격리 *(MITRE: T1190, T1505.003)*
* **권한 상승·비업무시간/이상 로그인·내부 이동 정밀 분석** — 관리자 탈취 징후를 조기 탐지하고 계정·세션·호스트를 자동 방어 *(MITRE: TA0004/TA0005/TA0008, 예: T1055, T1021)*
* **랜섬웨어 조기 탐지·자동 차단으로 피해 최소화** — 대량 암호화/복구 방해 행위를 식별해 프로세스 종료·격리·확산 차단·증거 보존까지 일괄 처리 *(MITRE: T1486, T1490)*

👉 [PLURA-XDR 침해사고 대응 서비스 자세히 보기](https://www.plura.io/underattack)

---

[1]: https://world.kbs.co.kr/service/news_view.htm?Seq_Code=195733&lang=e "Lotte Card Had Been Unaware of Hacking Incident for Over Two Weeks l KBS WORLD"
[2]: https://m.boannews.com/html/detail.html?idx=139047&tab_type=1&utm_source=chatgpt.com "롯데카드, 2017년 공개된 취약점에 당했다...“제2금융권 전반 ..."
[3]: https://www.thelec.kr/news/articleView.html?idxno=40144&utm_source=chatgpt.com "롯데카드, 서버 악성코드 감염…\"고객 정보 유출 없는 듯\""
[4]: https://koreajoongangdaily.joins.com/news/2025-09-02/business/industry/Watchdog-orders-Lotte-Card-to-compensate-victims-of-hack/2389681?utm_source=chatgpt.com "Watchdog orders Lotte Card to compensate victims of hack"
[5]: https://news.tvchosun.com/site/data/html_dir/2025/09/03/2025090390165.html?utm_source=chatgpt.com "해킹 공격 받은 롯데카드, 고객보호 조치 강화…\"피해 발생 시 선 ..."
[6]: https://www.businesskorea.co.kr/news/articleView.html?idxno=251136&utm_source=chatgpt.com "Lotte Card CEO Promises Full Compensation for Hacking ..."
[7]: https://www.lottecard.co.kr/app/LPEVNCA_V100.lc?newsSeq=3502 "롯데카드 개인 - 공지사항"
[8]: https://www.sedaily.com/NewsView/2GXQFL6KS6 "'회원 수 970만' 롯데카드 해킹 공격…고객정보 유출 여부 확인 중 | 서울경제"
[9]: https://www.khan.co.kr/article/202509012125001?utm_source=chatgpt.com "롯데카드도 '해킹 사고' 데이터 1.7GB 유출···“서버 악성코드 ..."

---
