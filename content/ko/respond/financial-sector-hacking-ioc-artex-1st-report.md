---
title: "[1보] 금융권 해킹 공격 IOC: ARTEX AI 관련 공개 지표와 즉시 점검 항목"
date: 2026-10-03
draft: false
description: "금융권 해킹 대응을 위해 ARTEX 공개 소스의 WAF 우선 검색용 후보 IOC와 도구 식별·설치 흔적을 구분합니다. 공격 IP의 공개 확인 범위, 세 User-Agent의 탐지 한계, API·인증·세션 점검 항목을 함께 정리합니다."
featured_image: "/cdn/respond/financial-sector-hacking-ioc-artex.png"
tags: ["금융권해킹", "ARTEX", "IOC", "AI해킹", "웹해킹", "WAF", "PLURA", "침해사고대응", "ThreatHunting", "사이버보안"]
---

# [1보] 금융권 해킹 공격 IOC
## ARTEX AI 관련 공개 지표와 즉시 점검 항목

> **2026년 10월 3일 · 1보 수정본**
>
> 이 문서는 금융권 공격 관련 공개 보도와 ARTEX 공개 소스 분석을 바탕으로 작성했습니다. 주요 코드 분석 기준은 **v0.3.14**입니다.
>
> **아래 세 User-Agent는 공개 소스에서 확인한 후보 지표이며, 이번 금융권 공격에서 실제 관측된 값으로 검증한 것은 아닙니다.** 본 문서에서는 실제 금융권 공격 로그를 확보해 대조하지 않았습니다.
>
> 공격 IP의 확보·금융권 공유 사실은 보도로 확인되지만, **본 문서에 공개 검증 가능한 구체적인 IP 주소 목록은 포함되어 있지 않습니다.**

최근 금융권을 대상으로 한 사이버 공격과 정보 유출 사고가 보도되고 있습니다. 금융위원회는 2026년 10월 2일 긴급 상황대응 회의를 열고 외부에 노출된 시스템·서비스의 보안점검과 위협정보 공유 등을 요청했습니다. [출처: 금융위원회][fsc]

금융보안원 관계자 설명을 인용한 10월 3일 보도에서는 신한은행의 공격 로그와 공격 IP를 조사하는 과정에서 **ARTEX 활용 흔적과 IP가 달라져도 나타나는 공통적인 요청 특징**을 확인했다고 설명했습니다. 다만 본 문서에서 확보한 공개자료만으로는 그 공통 특징의 정확한 값이 아래 후보 IOC와 같은지 확인할 수 없습니다. [출처: 헤럴드경제][herald]

**확인된 공격 IP는 핵심 IOC입니다. 여기에 HTTP 요청 특징과 인증·세션·API 접근 행위 분석을 함께 적용해야 합니다.**

<!--more-->

---

## 1. 공개 소스에서 확인한 WAF 우선 검색용 후보 IOC

ARTEX 공개 소스에는 공격 대상 웹시스템으로 전달될 수 있는 다음 User-Agent 문자열이 정의되어 있습니다.

| 우선순위 | 구분 | 후보 IOC | 소스에서 확인한 용도 |
|---|---|---|---|
| **1** | HTTP User-Agent | `artex-enrich/1.0` | 웹 자산 정보를 확인하는 HTTP 요청. [코드][enrich] |
| **2** | HTTP User-Agent | `Mozilla/5.0 (spa-api-recon)` | HTML·JavaScript 파일을 수집하는 정적 분석 스크립트. [코드][harvest] |
| **3** | HTTP User-Agent | `Mozilla/5.0 (spa-api-recon spider)` | 웹페이지를 순회하며 링크·폼 등을 수집하는 스크립트. [코드][spider] |

**우선순위는 조사 순서를 뜻합니다. ‘악성 확정’, ‘침해 성공’ 또는 ‘이번 금융권 사건과의 연관성 확정’을 뜻하지 않습니다.**

### 검색 및 초기 적용

웹방화벽, Reverse Proxy, 웹서버 Access Log, API Gateway 등 **HTTP User-Agent가 기록된 로그**에서 우선 다음 문자열을 검색합니다.

```text
artex-enrich/1.0
spa-api-recon
```

`spa-api-recon` 부분 문자열 검색에는 `spa-api-recon spider`도 포함됩니다. 검색 결과에서는 User-Agent 원문을 확인해 세 후보 중 어떤 값과 일치하는지 구분합니다.

파싱된 **User-Agent 필드 전체 값**에 세 후보를 대조하는 정규식 예시는 다음과 같습니다.

```regex
(?i)^(?:artex-enrich/1\.0|Mozilla/5\.0 \(spa-api-recon(?: spider)?\))$
```

위 정규식은 로그 한 줄 전체가 아니라 **User-Agent 값에 적용하는 예시**입니다. 적용 제품의 정규식 지원 방식에 맞춰 정상·탐지 샘플을 먼저 확인합니다.

권고하는 초기 운영 순서는 다음과 같습니다.

```text
후보 User-Agent 탐지
    → 정상 보안점검·모의해킹 사용 여부 확인
    → 요청 대상·인증 상태·전후 행위 분석
    → 비인가 요청에 대한 차단 정책 적용 검토
```

ARTEX는 공개 침투테스트 도구이므로 도구 식별과 악성 행위 판정을 구분해야 합니다. 탐지 우선순위를 높게 두더라도 User-Agent 일치만으로 침해 성공을 판정하지 않습니다. [출처: ARTEX 공개 저장소][repo]

### 세 User-Agent가 ARTEX 전체 요청을 대표하지는 않습니다

별도의 `runtime_harvest.js`는 Chromium 브라우저를 구동하고, 브라우저 요청의 헤더를 복사하거나 설정에 따라 쿠키를 적용하는 경로를 사용합니다. 앞의 두 Python 수집 스크립트와 요청 생성 방식이 다릅니다. [출처: 런타임 분석 코드][runtime]

따라서 **세 문자열을 차단했다고 ARTEX 전체를 차단한 것은 아닙니다.** 이들은 일부 기능의 후보 지표이며, 다른 실행 경로까지 포함하는 공통 시그니처로 확인된 것은 아닙니다.

> **판단 기준:** 소스에 해당 문자열이 있다는 사실, 조직 로그에 그 문자열이 관측됐다는 사실, 해당 요청이 실제 공격이었다는 판단은 각각 구분해야 합니다.

---

## 2. 공격 IP IOC와 현재·기존 로그 점검

### 공격 IP의 확보·공유와 공개 목록 확보는 다릅니다

10월 3일 보도에 따르면 금융보안원은 신한은행 조사에서 확보한 공격 IP를 금융권에 공유했고, 다른 은행들이 해당 IP의 접속 이력을 조사하는 과정에서 추가 침해 사실을 확인했습니다. 복수 은행의 공격 IP가 일부 겹쳤다는 설명도 있습니다. [출처: 헤럴드경제][herald]

| 구분 | 본 문서에서 확인한 범위 |
|---|---|
| 공격 IP 확보·금융권 공유 | 금융보안원 관계자 설명을 인용한 보도로 확인 |
| 다른 은행의 접속 이력 조사 활용 | 같은 보도에서 확인 |
| 외부에 재배포할 구체적인 IP 주소 목록 | **본 문서 작성 과정에서 확보하지 못함** |
| 추정 IP·ARTEX 서버 검색 결과 | 사건과의 연관성을 검증하지 않은 주소는 수록하지 않음 |

**‘공개 검증 가능한 주소 목록을 확보하지 못했다’는 것은 ‘공격 IP가 없다’거나 ‘관계기관이 확보하지 못했다’는 의미가 아닙니다.**

공식 공유 채널이나 해당 금융회사를 통해 공격 IP를 전달받았다면, 출처·관측 시각·역할·현재 적용 가능성을 확인한 뒤 **탐지·차단과 접속 이력 조사의 핵심 IOC**로 활용합니다. 외부 전파 시에는 재배포 허용 범위도 확인합니다.

### 현재 공격 대응과 접속 이력 조사를 함께 수행합니다

WAF에 후보 지표를 추가하는 것과 함께, 해당 지표가 이미 관측됐는지도 확인합니다. 우선 검색 대상은 **User-Agent를 실제 수집하는 WAF·Reverse Proxy·웹서버·API Gateway 로그**입니다. Load Balancer나 IDS/IPS 로그는 필요한 HTTP 정보가 기록되는 경우에 활용합니다.

초기 점검 범위로 **2026년 9월 하순부터 현재까지**를 우선 확인하고, 확보한 공격 IP의 관측 시각과 최초 탐지 결과에 따라 범위를 조정하는 방안을 권고합니다. 이는 점검 범위의 제안이며 **실제 공격 시작일을 확정한 것은 아닙니다.**

지표가 발견되면 해당 요청만 분리해서 보지 말고 같은 시간대의 요청, 대상 서비스, 인증·세션 상태와 연결해 분석합니다.

```text
공격 IP 또는 후보 User-Agent 확인
    → 대상 Host·URI·요청 시각 확인
    → 같은 세션·시간대의 요청 연결
    → 인증·권한 및 응답 내용 확인
    → 실제 공격 여부와 영향 범위 판단
```

**지표의 발견은 조사 시작점입니다. 반대로 세 User-Agent가 발견되지 않았다는 이유만으로 ARTEX 관련 활동이나 침해 가능성을 배제하지 않습니다.** 1절에서 설명한 별도 요청 생성 경로도 고려해야 합니다. [출처: 런타임 분석 코드][runtime]

---

## 3. ARTEX 도구 식별·설치 흔적

다음 항목은 **우리 웹서비스로 들어오는 공격 요청용 WAF 지표와 구분**합니다. ARTEX 관리 콘솔, 도구가 실행되는 호스트, 브라우저 또는 외부 통신을 조사할 때 활용하는 식별 지표입니다.

| 지표 | 확인할 위치 | 의미와 적용 범위 |
|---|---|---|
| `artex_token` | ARTEX 콘솔 이용 브라우저의 Cookie·Local Storage | 관리 콘솔의 인증 토큰 저장 키. **공격 대상 사이트로 보내는 고정 쿠키가 아님.** [코드][auth] |
| `artex-selfupdate` | HTTP 내용을 확인할 수 있는 외부 통신 로그 | ARTEX의 GitHub 릴리스 조회·업데이트 통신 식별. **금융회사로 들어오는 공격 요청용 지표가 아님.** [코드][selfupdate] |
| `ARTEX — 自主渗透测试控制台` | 의심 서버의 웹페이지·프런트엔드 자원 | 관리 콘솔의 제목 설정 문자열. 의미는 ‘ARTEX — 자율 침투테스트 콘솔’. [코드][appconfig] |
| `LLM 驱动的自主渗透测试系统控制台` | 의심 서버의 웹페이지·프런트엔드 자원 | 같은 UI 설정의 설명 문자열. 제목과 함께 확인할 보조 식별자. [코드][appconfig] |
| `autumn27/artex` | 컨테이너 이미지 목록·실행 이력 | 공식 Docker Compose의 이미지 이름. 비인가 도구 설치·실행 조사에 활용. [구성][compose] |
| `8787/tcp`·`8788/tcp` | 서비스 구성·리스닝 포트 | 기본 UI/API 및 트래픽 기록 프록시 구성. **포트 단독 판정·차단에는 사용하지 않음.** [구성][compose] |

### 관찰 위치를 반드시 구분합니다

`artex_token`은 ARTEX 관리 화면에서 인증 토큰을 저장하는 키입니다. 이를 **금융회사 웹서비스의 Cookie 차단 규칙으로 바로 옮기는 것은 근거가 부족합니다.** [출처: 콘솔 인증 코드][auth]

`artex-selfupdate`는 내부 호스트에서 비인가 ARTEX 실행 여부를 조사하는 단서로 사용할 수 있습니다. 다만 코드가 사용하는 GitHub는 업데이트 제공 경로이므로 **GitHub 도메인 자체를 공격자 도메인으로 분류해서는 안 됩니다.** [출처: 업데이트 코드][selfupdate]

기본 Docker Compose는 `8787:8787`을 매핑하고, 8788은 `127.0.0.1:8788:8788`로 호스트의 localhost에 바인딩합니다. 따라서 8788이 외부에서 열려 있어야 ARTEX라는 식의 판정은 맞지 않습니다. [출처: Docker Compose][compose]

**위 항목들이 함께 발견되면 ARTEX 설치·운영 여부를 조사할 근거가 됩니다. 그러나 그 시스템이 이번 금융권 공격에 사용됐다는 판단에는 실제 공격 기록과의 연결이 추가로 필요합니다.**

---

## 4. 행위 기반 점검: API 경로를 고정 IOC로 오해하지 않기

고정 IOC와 함께 API 접근·인증·세션 행위도 점검합니다. 다만 다음 경로를 **ARTEX 전용 공격 URL 목록으로 사용해서는 안 됩니다.**

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

공개 정찰 코드의 `API_HINT`는 HTML이나 JavaScript에서 추출한 경로를 API 후보로 분류하는 정규식입니다. 위 목록은 그 분류 패턴에 대응하는 예시이며, **ARTEX가 항상 이 경로들을 요청하거나 공격한다는 의미가 아닙니다.** [출처: 페이지 순회 코드][spider] · [정적 분석 코드][harvest]

정적 분석 스크립트에서 확인한 수집 흐름은 다음과 같습니다.

```text
진입 HTML 수집
    → JavaScript 참조 분석
    → Bundle·Chunk 파일 수집
    → API 후보 경로와 화면 경로 추출
```

스크립트는 여러 JavaScript 파일을 병렬로 수집합니다. 별도의 MPA Spider에는 최대 페이지 수 `200`, 깊이 `4`, 지연 설정 `0.1초`라는 기본값이 있습니다. 이는 **참고 스크립트의 기본 설정이지, 이번 공격에서 관측된 요청 수·속도나 고정 탐지 임계치가 아닙니다.** [출처: 정적 분석 코드][harvest] · [페이지 순회 코드][spider]

운영에서는 다음과 같은 조합을 조사 대상으로 삼는 방안을 권고합니다.

```text
확인된 공격 IP 또는 후보 User-Agent
    + 다수 URL·JavaScript 자원 접근
    + 여러 API에 대한 반복 요청
    + 파라미터·조회 대상의 반복 변경
    + 로그인·세션·권한 맥락이 맞지 않는 데이터 조회
```

이 조합은 **조사 방향을 제시하는 권고안**입니다. 각 행위가 이번 사건에서 모두 관측됐다는 의미는 아니며, ARTEX에만 고유한 행위로 판정해서도 안 됩니다.

---

## 5. WAF 차단 IOC에서 제외하거나 구분할 항목

공개 소스에서 문자열을 발견했다는 이유만으로 모두 WAF 차단 규칙에 넣지 않습니다.

| 항목 | WAF 수신 요청용 확정 지표로 사용하지 않는 이유 |
|---|---|
| `ARTEX-worker/1.0` | 확인한 공개 소스 검색 결과에서는 UI Mock 데이터의 요청 예시로 나타남. 실제 Worker의 공통 고정 User-Agent로 검증되지 않음. [코드][mock] |
| `artex-selfupdate` | 업데이트 통신용 User-Agent. 3절의 **외부 통신 조사용 지표**로 분류. [코드][selfupdate] |
| `artex_token` | ARTEX 콘솔 인증 정보 저장 키. 공격 대상에 전송되는 공통 쿠키로 확인되지 않음. [코드][auth] |
| `/api/`, `/graphql/`, `/admin/` 등 | 정찰 코드의 경로 분류 예시. 경로 일치만으로 ARTEX 사용이나 악성 행위를 판단하지 않음. [코드][spider] |
| `8787/tcp`, `8788/tcp` | 기본 구성 정보. 포트 번호만으로 ARTEX나 특정 사건의 공격 인프라를 판정하지 않음. [구성][compose] |

**‘WAF 수신 요청용 지표에서 제외한다’는 것과 ‘어떤 조사에서도 쓸모없다’는 것은 다릅니다.** 관찰 위치와 용도에 맞춰 분류해야 합니다.

---

## 6. ARTEX v0.3.14 공식 배포 ZIP의 SHA-256

다음 값은 공식 v0.3.14 릴리스에 게시된 **ZIP 배포파일의 SHA-256**입니다. 이번 금융권 공격에서 확보한 악성파일 해시가 아니며, 압축을 해제한 실행파일 자체의 해시도 아닙니다. [출처: 공식 릴리스][release] · [릴리스 자산 메타데이터][releaseapi]

```text
artex-0.3.14-linux-amd64.zip
d168ec58b836d6c58a7249f51894644da998f063271acd41af3545917f529c4b

artex-0.3.14-linux-arm64.zip
fff3f501db2ec8e2f424eabd33f009c6aff82ae3332a7b3118ad4038b11275af

artex-0.3.14-windows-amd64.zip
dde132714981bd6af672ce7a09bcd8010da5d106f7f9d64f4672adfb283ab252

artex-0.3.14-darwin-amd64.zip
5b45c239f24c5cb8002a996963f80d7b50cacee4a00e13c0f08a3f694064d81f

artex-0.3.14-darwin-arm64.zip
8a746590771e17146860c39fda44ed46d89b1749c90d8965f84acadf36613e0c
```

이 값은 조사 대상 시스템에서 동일한 배포 ZIP이 존재하는지 확인하는 **도구 설치·다운로드 흔적 조사용 참고정보**입니다. 금융권 사건의 악성파일 해시 목록으로 재배포하지 않습니다.

---

## 7. 지금 금융회사와 기업이 해야 할 일

### ① 확인된 공격 IP와 WAF 후보 지표를 함께 적용합니다

공식 공유 경로로 확보한 공격 IP는 출처·관측 시각·용도를 확인해 우선 대응에 활용합니다. 공개 소스에서 확인한 세 User-Agent는 별도의 **도구 식별 후보 지표**로 등록하고 정상 보안점검 여부를 확인합니다.

### ② 탐지 요청의 전후 맥락을 확인합니다

수집된 로그 범위에서 다음 항목을 연결합니다.

```text
발생 시각·출발지 IP·대상 Host
요청 메서드·URI·Query String·요청 본문
User-Agent·인증 및 세션 정보
응답 상태 코드·응답 크기·확인 가능한 응답 내용
관련 애플리케이션·서버 행위
```

세션과 인증 정보는 내부 조사에 필요한 범위에서 취급하고, 외부 공유본에는 고객정보와 인증정보가 노출되지 않도록 처리합니다.

### ③ 경로 이름이 아니라 접근 행위를 분석합니다

`/api/`라는 이름 자체를 차단하는 대신, 동일 주체의 반복 조회, 조회 대상의 연속 변경, 인증·권한 맥락과 맞지 않는 접근이 있는지 조사합니다. 요청·응답과 서버 측 기록을 함께 확인해 실제 영향을 판단합니다.

### ④ 탐지와 차단의 근거를 기록합니다

**사건에서 확인된 공격 IP**, **공개 소스의 후보 문자열**, **도구 설치 흔적**, **행위 이상**을 서로 다른 분류로 관리합니다. 후보 문자열 일치만으로 침해 성공을 확정하거나, 그 문자열이 없다는 이유로 조사를 종료하지 않습니다.

---

## 8. 이번 사고에서 가장 중요한 점

이번 대응의 핵심은 단순히 **‘AI가 해킹했다’**는 표현이나 특정 도구 이름에 있지 않습니다.

공개 코드에서 확인할 수 있는 것은 ARTEX에 웹 자산 확인, JavaScript 수집, API 후보 추출, 브라우저 기반 분석 등의 기능이 있다는 점입니다. 이 사실만으로 이번 금융권 공격에서 어떤 기능이 어느 순서로 실행됐는지, 실제로 어떤 취약점이 악용됐는지까지 확정할 수는 없습니다. [출처: 자산 확인 코드][enrich] · [정적 분석 코드][harvest] · [런타임 분석 코드][runtime]

따라서 대응의 기준은 다음처럼 잡는 것이 좋습니다.

> **확인된 공격 IP는 신속하게 대응하고, 공개 소스의 후보 IOC는 조사 단서로 활용하며, 실제 침해 여부는 요청·응답·인증·세션·서버 행위로 확인합니다.**

IP 기반 대응과 요청·행위 기반 탐지는 서로 대체하는 관계가 아닙니다.

---

## 결론

현재 본 문서에서 WAF 우선 검색용으로 제시하는 고정 문자열은 다음 세 가지입니다.

```text
artex-enrich/1.0
Mozilla/5.0 (spa-api-recon)
Mozilla/5.0 (spa-api-recon spider)
```

추가로 `artex_token`, `artex-selfupdate`, 콘솔 제목·설명, 컨테이너 이미지 등의 지표를 활용할 수 있지만, **이들은 별도의 도구 식별·설치 흔적 조사용입니다.** 기존 세 문자열과 같은 성격의 새로운 WAF 공격 지표로 묶지 않습니다.

**확인된 공격 IP는 핵심 IOC입니다.** 다만 본 문서에는 공개 검증 가능한 실제 주소 목록이 없으며, 임의의 ARTEX 서버 주소를 이번 사건의 공격 IP로 대신 제시하지 않습니다.

본 글은 **1보**입니다. 후속 보완의 핵심은 지표 수를 늘리는 것이 아니라, **실제 사건에서 관측된 IP·도메인·요청 특징을 출처와 관측 시각까지 확인해 추가하는 것**입니다.

---

## 📖 참고 자료

### 사건 관련 공개자료

- [금융위원회 — 최근 발생하는 금융권 침해위협에 면밀히 대응해 나가겠습니다, 2026-10-02][fsc]
- [헤럴드경제 — 금융보안원 관계자 설명을 인용한 ARTEX 활용 흔적·공격 IP 공유 관련 보도, 2026-10-03][herald]
- [연합뉴스 — 신한은행 공격 추정 인프라의 ARTEX 관련 흔적 보도, 2026-10-02][yna]

### ARTEX 공개 소스 및 배포정보

- [공개 저장소][repo] · [v0.3.14 릴리스][release] · [릴리스 자산 메타데이터][releaseapi]
- [웹 자산 확인 HTTP 요청 — enrich/enrich.go][enrich]
- [정적 HTML·JavaScript 수집 — harvest_static.py][harvest]
- [페이지 순회·링크·폼 수집 — spider_mpa.py][spider]
- [브라우저 기반 분석 — runtime_harvest.js][runtime]
- [콘솔 인증 토큰 저장 — web/src/lib/auth.ts][auth]
- [콘솔 제목·설명 — web/src/config/app-config.ts][appconfig]
- [컨테이너·포트 구성 — docker-compose.yml][compose]
- [GitHub 업데이트 요청 — selfupdate/github.go][selfupdate]
- [UI Mock 요청 예시 — web/src/lib/mock/data.ts, 검색으로 확인한 커밋 기준][mock]

[fsc]: https://www.fsc.go.kr/no010101/87869
[herald]: https://biz.heraldcorp.com/article/10892496
[yna]: https://www.yna.co.kr/view/AKR20261002042352017
[repo]: https://github.com/Autumn-27/ARTEX
[release]: https://github.com/Autumn-27/ARTEX/releases/tag/v0.3.14
[releaseapi]: https://api.github.com/repos/Autumn-27/ARTEX/releases/tags/v0.3.14
[enrich]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/enrich/enrich.go
[harvest]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/skills/api-recon/scripts/harvest_static.py
[spider]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/skills/api-recon/scripts/spider_mpa.py
[runtime]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/skills/api-recon/scripts/runtime_harvest.js
[auth]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/web/src/lib/auth.ts
[appconfig]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/web/src/config/app-config.ts
[compose]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/docker-compose.yml
[selfupdate]: https://github.com/Autumn-27/ARTEX/blob/v0.3.14/selfupdate/github.go
[mock]: https://github.com/Autumn-27/ARTEX/blob/d0033724a63aefbbcc1ed022b0faf4dc4a1fce51/web/src/lib/mock/data.ts
