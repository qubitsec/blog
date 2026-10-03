---
title: "[1보] 금융권 해킹 공격 IOC: ARTEX AI 관련 공개 지표와 즉시 점검 항목"
date: 2026-10-03
draft: false
description: "최근 금융권 해킹 공격과 관련해 ARTEX AI 활용 흔적이 확인되고 있습니다. 공개 ARTEX 소스에서 확인할 수 있는 HTTP User-Agent와 공격 인프라·행위 기반 IOC를 정리하고 즉시 점검할 항목을 공유합니다."
featured_image: "/cdn/respond/financial-sector-hacking-ioc-artex.png"
tags: ["금융권해킹", "ARTEX", "IOC", "AI해킹", "웹해킹", "WAF", "PLURA", "침해사고대응", "ThreatHunting", "사이버보안"]
---


## ARTEX AI 관련 공개 지표와 즉시 점검 항목

> **2026년 10월 3일 1보**
>
> 현재 공격과 조사가 진행 중입니다.
>
> 본 문서의 IOC에는 **금융보안원이 공개한 실제 공격 IOC 값이 아니라, 공개된 ARTEX 소스코드에서 확인한 후보 IOC**가 포함되어 있습니다.
>
> 실제 금융권 공격 로그와 대조해 동일한 특징이 확인되는 경우 신뢰도는 크게 높아질 수 있습니다.

최근 금융권을 대상으로 한 사이버 공격과 정보 유출 사고가 이어지고 있습니다.

금융위원회는 2026년 10월 2일 금융감독원·금융보안원·은행·카드사 등과 긴급 상황대응 회의를 열고 **외부에 노출된 전산시스템과 서비스 전반에 대한 보안점검, 인증·접근통제 취약점 점검, 공격 IP 등 위협정보 공유**를 요청했습니다.

특히 주목해야 할 부분은 공격 과정에서 **ARTEX라는 AI 기반 자율 침투테스트 도구의 흔적이 확인되고 있다는 점**입니다.

금융보안원 관계자 설명을 인용한 보도에 따르면 신한은행의 공격 로그와 공격자 IP를 역추적하는 과정에서 ARTEX 활용 흔적이 발견됐으며, 공격자가 IP를 변경하더라도 **공격 데이터에는 ARTEX에서 발신되는 공통적인 특징이 존재한다**는 취지의 설명이 나왔습니다.

따라서 지금 필요한 대응은 단순한 **공격 IP 차단만이 아닙니다.**

**IP가 아니라 HTTP 요청과 공격 행위 자체에서 ARTEX의 흔적을 찾아야 합니다.**

---

## 1. 가장 먼저 검색해야 할 ARTEX 후보 IOC

공개 ARTEX 소스코드를 분석하면 공격 대상 웹시스템으로 전달될 수 있는 다음 User-Agent 문자열을 확인할 수 있습니다.

| 우선순위 | 구분 | 후보 IOC | 판단 |
|---|---|---|---|
| **1** | HTTP User-Agent | `artex-enrich/1.0` | **높은 우선순위** |
| **2** | HTTP User-Agent | `Mozilla/5.0 (spa-api-recon)` | **높은 우선순위** |
| **3** | HTTP User-Agent | `Mozilla/5.0 (spa-api-recon spider)` | **높은 우선순위** |

ARTEX의 공개 코드에서 `artex-enrich/1.0`은 웹 자산을 자동 확인하는 HTTP Probe의 User-Agent로 설정되어 있습니다.

또한 ARTEX의 API Recon 기능에는 각각 다음 User-Agent가 하드코딩되어 있습니다.

```text
Mozilla/5.0 (spa-api-recon)
Mozilla/5.0 (spa-api-recon spider)
```

따라서 웹방화벽, Reverse Proxy, 웹서버 Access Log, API Gateway 로그에서 우선 다음 세 문자열을 검색할 것을 권고합니다.

```text
artex-enrich/1.0
spa-api-recon
spa-api-recon spider
```

통합 검색 정규식은 다음과 같이 구성할 수 있습니다.

```regex
(?i)^(?:artex-enrich/1\.0|Mozilla/5\.0 \(spa-api-recon(?: spider)?\))$
```

다만 이것은 현재 **공개 ARTEX 소스에서 추출한 후보 IOC**입니다.

금융보안원이 언급한 실제 공격의 “ARTEX 공통 데이터”가 위 문자열과 동일하다고 아직 공개적으로 확인된 것은 아닙니다.

따라서 현재 단계에서는 다음과 같이 운영하는 것이 적절합니다.

```text
artex-enrich/1.0
    → HIGH 탐지
    → 조직에서 ARTEX를 사용하지 않는다면 차단 검토

spa-api-recon
spa-api-recon spider
    → HIGH 탐지
    → 정상 보안점검·Red Team 사용 여부 확인
    → 미사용 조직이면 차단 검토
```

---

## 2. 반드시 과거 로그도 즉시 검색해야 합니다

IOC를 WAF에 추가하는 것만으로 끝나서는 안 됩니다.

현재 공격을 막는 것과 함께 **이미 공격을 받았는지 확인하는 작업**이 필요합니다.

특히 다음 로그를 대상으로 검색해야 합니다.

```text
WAF
Reverse Proxy
Nginx / Apache
Web Server
API Gateway
Load Balancer
IDS / IPS
HTTP Full Log
```

검색 대상 기간은 최소한 **2026년 9월 하순부터 현재까지**를 우선 확인하고, 여건이 된다면 더 이전 기간까지 확대하는 것이 좋습니다.

다음 세 문자열이 과거 로그에서 발견된다면 해당 요청의 전후 트래픽을 반드시 함께 조사해야 합니다.

```text
artex-enrich/1.0
spa-api-recon
spa-api-recon spider
```

단순히 해당 문자열이 발견됐다는 이유만으로 침해가 확정되는 것은 아닙니다.

ARTEX는 공개된 침투테스트 플랫폼이므로 정상적인 보안점검에서도 사용될 수 있습니다.

반대로 **해당 문자열이 없다고 공격받지 않았다는 의미도 아닙니다.**

User-Agent는 공격자가 쉽게 변경할 수 있기 때문입니다.

---

## 3. ARTEX 공격 인프라를 찾을 때 사용할 수 있는 지표

ARTEX 공개 UI에는 다음 HTML Title이 정의되어 있습니다.

```text
ARTEX — 自主渗透测试控制台
```

의미는 대략 다음과 같습니다.

```text
ARTEX — 자율 침투테스트 콘솔
```

따라서 외부 공격 서버나 의심 인프라를 조사할 때 이 HTML Title이 확인된다면 **ARTEX 서버일 가능성을 높이는 지표**로 활용할 수 있습니다.

ARTEX v0.3.14의 기본 설정에는 다음 포트도 존재합니다.

```text
8787/tcp
    ARTEX Web UI / API

8788/tcp
    Traffic Recording Proxy
```

그러나 **포트 번호 자체를 IOC로 사용해서는 안 됩니다.**

8787과 8788은 다른 서비스에서도 충분히 사용할 수 있습니다.

또한 공개 Docker Compose 구성에서는 8788이 `127.0.0.1`에 바인딩되므로 외부에서 직접 보이지 않을 수도 있습니다.

따라서 공격 인프라 탐색에서는 다음과 같은 조합이 더 의미가 있습니다.

```text
HTML TITLE
    ARTEX — 自主渗透测试控制台

+
ARTEX 관련 서비스 구조

+
8787 등 기본 포트

+
공격 대상 시스템에서 확인된 HTTP IOC
```

---

## 4. ARTEX의 행동도 함께 탐지해야 합니다

고정 문자열 IOC보다 더 중요한 것은 **행위 기반 탐지**입니다.

ARTEX의 공개 API Recon 코드에서는 다음과 같은 URL 패턴을 수집 대상으로 사용합니다.

```text
/api/
/rest/
/service/
/ajax/
/action/
/do/
/rpc/
/graphql/
/v1/
/v2/
/admin/
/backend/
```

또한 SPA 웹사이트를 분석할 때 다음과 같은 흐름이 나타날 수 있습니다.

```text
웹사이트 접속
        ↓
HTML 분석
        ↓
JavaScript Bundle 수집
        ↓
Chunk JavaScript 다수 다운로드
        ↓
API Endpoint 추출
        ↓
API 및 Parameter 탐색
```

공개된 MPA Spider는 기본 설정으로 다음 값을 사용합니다.

```text
Maximum Pages : 200
Depth         : 4
Delay         : 0.1 sec
```

SPA 정찰 기능 역시 여러 JavaScript 파일과 Chunk를 병렬로 수집합니다.

따라서 다음과 같은 패턴이 함께 나타난다면 위험도를 높여 판단할 필요가 있습니다.

```text
짧은 시간 동안 다수 URL 접근
+
JavaScript Bundle/Chunk 대량 다운로드
+
/api/, /graphql/, /admin/ 등 Endpoint 탐색
+
Parameter 반복 변경
+
인증되지 않은 데이터 조회 시도
+
User-Agent = spa-api-recon 계열
```

이런 조합은 단일 IOC보다 훨씬 강한 탐지 근거가 됩니다.

---

## 5. ARTEX IOC로 사용하면 안 되는 문자열

공개 코드를 검색하면 다음 문자열도 발견됩니다.

```text
ARTEX-worker/1.0
```

그러나 현재 공개 소스에서 이 문자열은 **실제 Worker의 고정 User-Agent가 아니라 UI Mock 데이터에 포함된 예시 문자열**입니다.

따라서 현재 단계에서는 WAF 차단 IOC로 사용하지 않는 것이 좋습니다.

또 다음 문자열도 존재합니다.

```text
artex-selfupdate
```

이 User-Agent는 ARTEX 자체 업데이트 과정에서 GitHub 등으로 요청할 때 사용됩니다.

따라서 금융회사 웹서비스로 들어오는 공격 요청을 식별하기 위한 WAF IOC로는 적절하지 않습니다.

정리하면 다음과 같습니다.

```text
[우선 탐지]

artex-enrich/1.0
Mozilla/5.0 (spa-api-recon)
Mozilla/5.0 (spa-api-recon spider)


[현재 WAF IOC에서 제외]

ARTEX-worker/1.0
artex-selfupdate
```

---

## 6. ARTEX v0.3.14 공식 배포파일 SHA-256

ARTEX GitHub에는 2026년 9월 24일 **v0.3.14**가 공개됐습니다.

공식 Release의 SHA-256은 다음과 같습니다.

```text
Linux amd64
d168ec58b836d6c58a7249f51894644da998f063271acd41af3545917f529c4b

Linux arm64
fff3f501db2ec8e2f424eabd33f009c6aff82ae3332a7b3118ad4038b11275af

Windows amd64
dde132714981bd6af672ce7a09bcd8010da5d106f7f9d64f4672adfb283ab252

macOS amd64
5b45c239f24c5cb8002a996963f80d7b50cacee4a00e13c0f08a3f694064d81f

macOS arm64
8a746590771e17146860c39fda44ed46d89b1749c90d8965f84acadf36613e0c
```

**주의해야 합니다.**

이 값들은 금융권 공격에서 확보된 악성파일 해시가 아닙니다.

정상적으로 공개된 **ARTEX 공식 배포파일의 해시**입니다.

따라서 이를 일반적인 Malware Block IOC로 배포해서는 안 됩니다.

공격자 서버, 침해 시스템 또는 비인가 침투테스트 도구 설치 여부를 조사할 때 사용하는 **Threat Hunting 참고정보**로 분류하는 것이 적절합니다.

---

## 7. 지금 금융회사와 기업이 해야 할 일

현재 단계에서 가장 먼저 해야 할 일은 공격 IP 목록만 추가하는 것이 아닙니다.

**HTTP 요청 데이터 자체를 조사해야 합니다.**

### ① 현재 WAF·웹서버 로그 검색

```text
artex-enrich/1.0
spa-api-recon
spa-api-recon spider
```

### ② 발견 시 해당 IP만 보지 말고 같은 세션·시간대 전체 요청 분석

```text
URI
Query String
POST Body
Header
Cookie
User-Agent
Response Code
Response Size
Session
```

### ③ API Enumeration 여부 확인

```text
/api/
/graphql/
/admin/
/rest/
/service/
```

등 다수의 Endpoint를 짧은 시간에 탐색했는지 확인합니다.

### ④ 정상적인 보안점검에서 ARTEX를 사용하지 않는 조직이라면 차단 검토

특히 정확히 일치하는 User-Agent는 초기 긴급 대응용 탐지·차단 정책으로 활용할 수 있습니다.

### ⑤ IP IOC는 보조수단으로만 사용

공격자는 IP를 계속 변경할 수 있습니다.

이번 사고에서도 중요한 것은 **공격 IP 자체보다 공격 데이터에 남는 공통 특징을 찾는 것**입니다.

---

## 8. 이번 사고에서 가장 중요한 점

이번 금융권 공격에서 주목해야 할 것은 단순히 “**AI가 해킹했다**”는 표현이 아닙니다.

현재 공개된 정황으로는 사람이 AI 기반 침투테스트 도구를 공격에 활용한 형태로 이해하는 것이 더 정확합니다.

중요한 변화는 다른 곳에 있습니다.

과거에는 공격자가 직접 수행해야 했던

```text
웹사이트 분석
→ JavaScript 분석
→ API 발견
→ 취약점 탐색
→ Parameter 변경
→ 반복 공격
```

과정을 AI Agent가 훨씬 빠르게 반복할 수 있게 됐다는 점입니다.

공격 속도가 빨라진다면 방어도 달라져야 합니다.

**알려진 공격 IP를 차단하고 기다리는 방식으로는 충분하지 않습니다.**

웹 요청과 응답, API 접근, 인증·세션, 서버 행위를 실시간으로 분석하여 **공격의 흐름 자체를 탐지해야 합니다.**

---

## 결론

금융권 해킹 공격은 현재도 조사 중이며 새로운 IOC가 추가될 가능성이 높습니다.

현재 공개 ARTEX 소스에서 가장 먼저 확인할 수 있는 후보 IOC는 다음 세 가지입니다.

```text
artex-enrich/1.0
Mozilla/5.0 (spa-api-recon)
Mozilla/5.0 (spa-api-recon spider)
```

하지만 IOC 하나에만 의존해서는 안 됩니다.

```text
IOC
+
URL 탐색 패턴
+
API Enumeration
+
Parameter 반복 변경
+
인증·세션 이상
+
웹 요청·응답 로그
```

를 함께 분석해야 합니다.

특히 **ARTEX 관련 문자열이 실제 금융권 공격 로그에서도 확인된다면 공개 소스와 실제 공격을 직접 연결하는 중요한 IOC가 될 수 있습니다.**

본 글은 **1보**입니다.

금융보안원 또는 금융당국에서 실제 공격 데이터의 세부 IOC가 추가 공개되거나 금융권 실제 로그와 공개 ARTEX 지표의 대조 결과가 확인되는 경우 후속 내용을 업데이트할 예정입니다.

---

## 📖 참고 자료

- 금융위원회, 「최근 발생하는 금융권 침해위협에 면밀히 대응해 나가겠습니다」, 2026-10-02  
  https://www.fsc.go.kr/no010101/87869
- 연합뉴스, 금융권 해킹 및 ARTEX 관련 보도, 2026-10-02  
  https://www.yna.co.kr/view/AKR20261002042352017
- 헤럴드경제, 금융보안원 ARTEX 활용 흔적 관련 보도, 2026-10-03  
  https://biz.heraldcorp.com/article/10892496
- ARTEX 공개 저장소  
  https://github.com/Autumn-27/ARTEX
- ARTEX v0.3.14 Release  
  https://github.com/Autumn-27/ARTEX/releases/tag/v0.3.14
