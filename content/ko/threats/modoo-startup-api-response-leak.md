---
title: "‘모두의창업’ 정보 유출, 핵심은 “AI 도구”가 아니라 “백엔드 API와 암호키 노출”이다"
date: 2026-06-25
lastmod: 2026-08-02
draft: false
description: "39개 국내 IP의 비공개 API 접근, 합격자 5천 명 정보 유출과 암호키 노출을 바탕으로, PLURA-WAF 응답본문 분석과 PLURA-XDR 상관분석으로 유출을 어떻게 탐지할 수 있었는지 구체적으로 분석합니다."
featured_image: "/cdn/threats/modoo-startup-api-response-leak.png"
tags: ["PLURA-XDR", "PLURA-WAF", "API 보안", "정보유출", "응답본문분석", "암호키 관리", "웹 크롤링"]
---

## 핵심만 보기

> **2026년 7월 31일 후속 발표 반영**  
> 중소벤처기업부의 후속 설명에 따르면 비공개 정보가 포함된 API에 **39개의 국내 IP가 접근을 시도**했고, 합격자 **5천 명의 이메일 주소·심사평·창업 아이디어 요약** 등이 유출되었습니다. 특히 암호화된 정보와 함께 **소스코드 형태의 암호키도 노출돼 복호화가 가능했던 것**으로 확인됐습니다. 다만 39개 IP 모두가 실제 유출에 성공했는지, 특정 AI 솔루션 업체와 어떤 관계가 있는지는 경찰이 수사 중입니다.

* 이번 사건의 본질은 “AI 도구” 자체가 아니라 **비공개 백엔드 API 접근, 과도한 응답 데이터, 웹 크롤링, 암호키 관리 실패**입니다.
* 초기 발표에서는 9개 IP가 언급됐지만, 후속 조사에서는 **39개 국내 IP의 접근 시도**가 확인됐습니다.
* 유출된 것으로 확인된 정보는 합격자 5천 명의 이메일 주소, 심사평, 창업 아이디어 요약 등입니다.
* 개인정보가 암호화돼 있었더라도 **데이터와 복호화 가능한 암호키가 함께 노출**됐다면 암호화의 보호 효과는 사실상 사라집니다.
* 후속 발표로 **웹 크롤링 사용은 확인**됐지만, AI 솔루션 업체의 구체적인 연관성은 아직 수사 중입니다.
* 정확한 요청 횟수와 객체 ID 변화가 공개되지 않았으므로 “API 브루트포스”를 확정할 수는 없지만, 보안 관점에서는 **분산 API Enumeration·과요청·자동 수집**으로 탐지했어야 할 유형입니다.
* IP별 임계치만으로는 39개 IP에 분산된 접근을 놓칠 수 있으므로, **API·계정·세션·객체·응답 데이터 기준의 상관분석**이 필요합니다.
* PLURA-WAF는 웹 응답본문의 **유출정보**, 응답 상태값, 응답 크기와 원본 `Resp-body1`을 확인해 실제 외부로 전달된 데이터를 탐지할 수 있습니다.
* PLURA-XDR은 이 응답 유출 이벤트를 API·객체·계정·세션·다수 IP의 호출 행위와 연결해 고위험 사고로 승격하고 후속 접근을 차단할 수 있습니다.
* 단, 암호화된 값만 응답됐다면 일반 개인정보 정규식으로는 탐지하기 어렵습니다. 민감 API의 금지 필드, 암호키·Secret 노출, 응답 크기와 반복 성공 응답까지 함께 봐야 합니다.

---

## 1) 사건 개요

‘모두의창업’ 사고는 처음에는 **“AI 도구를 이용한 백엔드 API 비정상 접근”**으로 알려졌습니다.

그러나 2026년 7월 31일 중소벤처기업부의 후속 브리핑으로 사건의 핵심이 보다 구체적으로 드러났습니다.

```text
비공개 정보가 포함된 API
        ↓
39개 국내 IP의 접근 시도
        ↓
웹 크롤링을 통한 자동 수집
        ↓
합격자 5천 명의 이메일·심사평·아이디어 요약 유출
        ↓
암호화된 정보와 암호키가 함께 노출
        ↓
평문으로 복호화 가능
```

즉, 이번 사건은 단순히 “AI가 정보를 수집했다”는 문제가 아닙니다.

> **외부에서 접근 가능한 비공개 API가 과도한 데이터를 반환했고, 자동 수집을 막지 못했으며, 암호화된 정보와 이를 풀 수 있는 암호키까지 같은 노출 경로에 포함된 복합적인 API 보안 실패입니다.**

### 1-1. 초기 발표와 후속 조사에서 달라진 점

중기부는 6월 18일 설명자료에서 6월 15일 오전 합격자 프로필 공개 이후 비공개 정보 접근 시도를 확인했고, 이용자 문의를 통해 이를 인지한 뒤 같은 날 접근 경로를 차단했다고 밝혔습니다. 당시에는 **9개 IP**를 통해 이메일 주소, 아이디어 요약, 심사평이 유출된 것으로 파악됐습니다.

7월 31일 후속 브리핑에서는 조사 범위가 확대됐습니다.

| 구분 | 6월 18일 초기 설명 | 7월 31일 후속 발표 |
| --- | --- | --- |
| 확인된 IP | 9개 IP | 비공개 API에 39개 국내 IP 접근 시도 |
| 영향 대상 | 합격자 5천 명 | 합격자 5천 명 |
| 확인 정보 | 이메일, 아이디어 요약, 심사평 | 이메일, 심사평, 창업 아이디어 요약 등 |
| 공격 수단 | 외부 AI 기반 자동 수집 시도 | 해당 업체의 웹 크롤링 사용 확인 |
| 암호키 | 공개되지 않음 | API에 암호키가 함께 있어 유출·복호화 가능 확인 |
| 수사 상태 | 추가 조사 | 세부 IP와 AI 솔루션 업체 연관성 경찰 수사 중 |

IP 수가 9개에서 39개로 늘어난 것은 초기 발표가 허위였다는 의미로 단정할 수는 없습니다. 초기 조사 이후 추가 로그와 외부 전문기관 분석을 통해 관련 접근 범위가 확대됐을 수 있습니다.

다만 이 변화는 사고 초기 발표만으로 피해 범위를 확정해서는 안 되며, **모든 API 접근 로그를 충분히 보존하고 재구성할 수 있어야 한다**는 점을 보여 줍니다.

### 1-2. “AI 도구”라는 표현은 더 신중하게 써야 한다

후속 발표로 확인된 것은 다음 두 가지입니다.

1. 사고에 **웹 크롤링 방식**이 사용됐다는 점
2. 특정 AI 솔루션 업체와 접근 IP의 구체적인 연관성은 **경찰 수사 중**이라는 점

따라서 다음과 같이 구분해야 합니다.

| 구분 | 판단 |
| --- | --- |
| 웹 크롤링을 이용한 자동 수집 | 후속 발표로 확인 |
| 특정 AI 도구의 제품명·기능 | 공개되지 않음 |
| AI 솔루션 업체가 직접 유출을 수행했는지 | 경찰 수사 중 |
| AI가 새로운 취약점을 만든 것인지 | 아님 |

AI는 취약점이 아닙니다.

AI나 자동화 도구는 API 주소 탐색, 호출 스크립트 작성, 응답 데이터 정리 등을 빠르게 할 수 있지만, 정보가 유출된 직접 원인은 **서버가 허가되지 않은 요청에 비공개 정보를 반환했고, 그 응답에 암호키까지 포함시킨 것**입니다.

---

### 참고 및 한계

본 글은 중기부의 6월 18일 설명자료와 7월 31일 후속 브리핑 보도를 바탕으로 작성했습니다.

후속 발표로 다음 사실은 확인됐습니다.

* 비공개 정보가 포함된 API에 39개 국내 IP가 접근을 시도함
* 합격자 5천 명의 이메일 주소, 심사평, 창업 아이디어 요약 등이 유출됨
* 암호화된 정보와 소스코드 형태의 암호키가 함께 노출됨
* 유출된 정보를 평문으로 복호화할 수 있었음
* 사고 업체가 웹 크롤링 방식을 사용함

그러나 다음 사항은 아직 공개자료만으로 확인하기 어렵습니다.

* 39개 IP 중 실제 데이터 수집에 성공한 IP 수
* 각 IP의 호출 횟수, 시간대, User-Agent, 요청 속도
* 동일 업체가 직접 사용한 IP인지, 클라우드·프록시·공유망인지
* 객체 ID를 순차적으로 바꿨는지, 페이지 크기를 조작했는지
* 인증 우회, BOLA/IDOR, 공개되지 않은 API 경로 중 어떤 문제가 있었는지
* WAF 적용 여부와 Backend API 보호 대상 등록 상태
* API 요청·응답본문 전체 로그가 어느 범위까지 보존됐는지
* 암호키의 종류, 사용 범위, 회전·폐기 여부
* AI 솔루션 업체와 접근 주체의 구체적인 관계

따라서 확인된 사실과 기술적 분석을 구분해 설명합니다.

---

## 2) 밝혀진 사실

현재 공개적으로 확인되는 핵심은 다음과 같습니다.

| 구분 | 확인된 내용 |
| --- | --- |
| 사고 대상 | ‘모두의창업’ 플랫폼의 비공개 정보 포함 API |
| 접근 정황 | 39개 국내 IP가 해당 API에 접근을 시도 |
| 영향 대상 | 프로젝트 합격자 5천 명 |
| 유출 정보 | 이메일 주소, 심사평, 창업 아이디어 요약 등 |
| 자동화 방식 | 사고 관련 업체가 웹 크롤링 방식 사용 |
| 암호화 상태 | 정보는 암호화돼 있었음 |
| 암호키 관리 | 소스코드 형태의 암호키가 API에 함께 포함돼 유출 |
| 결과 | 유출된 데이터를 평문으로 복호화할 수 있었음 |
| 수사 중인 부분 | 세부 IP 내용과 AI 솔루션 업체의 연관성 |
| 정부 개선책 | API 응답 최소화, 외부 보안 검증, DB 암호화 강화, 모든 API 접근 로그 기록, 크롤링 차단 고도화, 최소권한 재설계 |

여기서 **39개 국내 IP**는 39명의 공격자 또는 39개 업체를 의미하지 않습니다.

하나의 주체가 여러 IP를 사용했을 수도 있고, 클라우드·프록시·공유망을 이용했을 수도 있습니다. 반대로 여러 주체가 접근했을 가능성도 남아 있습니다. 현재는 접근 주체와 IP의 관계가 수사 중이므로 이를 단정하면 안 됩니다.

또한 다음 내용도 아직 단정할 수 없습니다.

* SQL Injection이나 웹셸 업로드가 있었다고 단정할 수 없음
* 관리자 계정이 탈취됐다고 단정할 수 없음
* BOLA/IDOR가 공식 원인으로 확인됐다고 단정할 수 없음
* 39개 IP 모두가 개인정보 유출에 성공했다고 단정할 수 없음
* 전통적인 로그인 브루트포스 공격이었다고 단정할 수 없음
* 특정 AI 솔루션 업체가 직접 공격했다고 단정할 수 없음
* WAF가 없었거나 정상 작동하지 않았다고 단정할 수 없음

다만 후속 발표로 다음 판단은 더욱 분명해졌습니다.

> **이번 사고는 “AI 도구를 사용했는가”보다, 비공개 API가 자동 수집을 허용하고 개인정보와 암호키까지 외부에 반환한 구조가 핵심입니다.**

---

## 3) 공격 방법 설명

### 3-1. 확인된 공격 흐름과 미확인 부분

후속 발표를 기준으로 확인된 흐름은 다음과 같습니다.

```text
합격자 프로필 공개
        ↓
비공개 정보가 포함된 API 접근 경로 확인
        ↓
39개 국내 IP에서 접근 시도
        ↓
웹 크롤링 방식으로 자동 수집
        ↓
이메일·심사평·아이디어 요약 응답
        ↓
암호화 데이터와 암호키 동반 노출
        ↓
평문 복호화 가능
```

이 흐름에서 **웹 크롤링**과 **암호키 동반 노출**은 확인됐지만, 공격자가 비공개 API를 어떻게 발견하고 호출 권한을 얻었는지는 아직 공개되지 않았습니다.

가능한 기술적 원인으로는 다음이 있지만, 어느 하나도 공식 확인된 것은 아닙니다.

* 프론트엔드 JavaScript나 네트워크 요청에서 API 주소 노출
* 인증 없이 접근 가능한 비공개 API
* 로그인 사용자가 다른 사람의 데이터를 조회할 수 있는 BOLA/IDOR
* 서버 측 권한 검증 누락
* 예측 가능한 객체 ID 또는 페이지 파라미터
* 과도한 Page Size나 검색 조건을 이용한 대량 응답

AI 도구는 취약점 자체가 아닙니다.

공격자는 AI나 일반 자동화 도구를 이용해 다음 작업을 빠르게 수행할 수 있습니다.

* JavaScript에서 API 주소 추출
* 브라우저 개발자 도구의 요청 구조 분석
* API 파라미터와 식별자 변경
* 반복 호출 스크립트 작성
* 응답 JSON에서 이메일·심사평·아이디어 정보 추출
* 여러 IP로 호출을 분산해 단순 임계치 우회

그러나 서버가 객체별 권한을 검증하고, 응답 데이터를 최소화하며, 암호키를 별도 관리했다면 자동화 도구만으로 정보가 유출될 수 없습니다.

---

### 3-2. 공격 흐름

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontFamily": "Pretendard, Noto Sans KR, Arial",
    "background": "#ffffff",
    "primaryTextColor": "#0f172a",
    "lineColor": "#1f2937"
  },
  "themeCSS": "
    .node rect, .node circle, .node ellipse, .node polygon {
      filter: drop-shadow(0px 4px 8px rgba(15, 23, 42, 0.16));
    }
    .edgePath path { stroke-width: 2.6px; }
    .edgeLabel { background-color: #ffffff; color: #0f172a; font-weight: 700; }
  "
}}%%

flowchart LR

    A["🌐<br/><b>39개 국내 IP</b><br/>접근 시도"] --> B["🤖<br/><b>웹 크롤링</b><br/>자동 API 호출"]
    B --> C{"🔐<br/><b>API 권한 검증</b><br/>충분했는가?"}
    C -- "검증 미흡" --> D["📄<br/><b>API 응답</b><br/>이메일·심사평·아이디어"]
    D --> E["🔑<br/><b>암호키 동반 노출</b><br/>소스코드 형태"]
    E --> F["🔓<br/><b>복호화 가능</b><br/>평문 정보"]
    F --> G["🚨<br/><b>정보 유출</b><br/>합격자 5천 명"]

    classDef attacker fill:#fff1f2,stroke:#ef4444,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef normal fill:#eff6ff,stroke:#1e88e5,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef warn fill:#fff7ed,stroke:#f97316,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef danger fill:#ffe5e5,stroke:#d32f2f,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;

    class A,B attacker;
    class C warn;
    class D,E normal;
    class F,G danger;

    linkStyle 0,1,2,3,4,5 stroke:#1f2937,stroke-width:2.6px;
```

---

### 3-3. 이 공격은 브루트포스인가?

이번 유형을 전통적인 **로그인 브루트포스 공격**으로 부르는 것은 적절하지 않습니다.

후속 발표로 확인된 표현은 **웹 크롤링**과 **39개 IP의 비공개 API 접근 시도**입니다. 정확한 호출 횟수, 객체 ID 변화, 요청 간격은 공개되지 않았으므로 “API 브루트포스가 발생했다”고 확정해서도 안 됩니다.

다만 탐지 관점에서는 다음 유형으로 다뤄야 합니다.

```text
자동화된 API 접근
API Enumeration
분산 API 과요청
서로 다른 객체의 반복 조회
다수 IP에서 동일 민감 API 접근
개인정보 포함 응답의 반복 수신
```

즉, 표현은 다음과 같이 정리하는 것이 정확합니다.

> **공격 분류를 로그인 브루트포스로 확정할 수는 없다. 그러나 보안 탐지 관점에서는 웹 크롤링 기반의 분산 API Enumeration·과요청으로 탐지하고 통제했어야 한다.**

특히 39개 IP에 접근이 분산됐다면 IP 하나당 호출 횟수만 계산하는 정책은 우회될 수 있습니다.

| 단순 탐지 | 필요한 탐지 |
| --- | --- |
| IP 하나의 요청 횟수 | 여러 IP가 동일 API·객체 범위를 조회하는지 분석 |
| 로그인 실패 횟수 | 성공 응답과 반환 데이터의 민감도 분석 |
| User-Agent 한 개 | User-Agent·세션·토큰·호출 패턴의 군집 분석 |
| 공격 문자열 | 정상 형식 요청의 반복성과 결과 데이터 분석 |
| IP 평판 | 국내 정상 IP처럼 보여도 행위 기반으로 판단 |

중요한 질문은 다음입니다.

> **39개 IP가 동일한 API와 유사한 객체 범위를 반복 조회했는가?**  
> **각 IP는 임계치 아래였지만 전체적으로는 대량 수집이었는가?**  
> **동일 계정·세션·토큰 또는 유사한 요청 패턴이 연결됐는가?**  
> **응답에 개인정보와 암호키가 반복 포함됐는가?**

---

### 3-4. 응답본문 분석이라면 어떻게 탐지할 수 있었는가?

PLURA 공식 문서는 웹 탐지 로그에 **요청본문과 응답본문 정보가 포함**되며, `유출정보` 항목에서 웹 서버 응답본문에서 탐지된 기밀정보와 사용자 정보를 확인할 수 있다고 설명합니다. 또한 상태값과 응답 크기를 함께 제공하고, 원본 로그에서는 데이터 유출 필터에 탐지된 응답을 `Resp-body1`과 같은 형태로 확인할 수 있습니다.

* [PLURA-XDR 데이터유출](https://docs.plura.io/ko/v6/fn/comm/sdetection/databreach)
* [PLURA 웹 필터탐지](https://docs.plura.io/ko/fn/waf/detection)
* [PLURA 웹 탐지 로그](https://docs.plura.io/ko/fn/comm/fdetection/web)

이 기능을 이번 사고에 적용한다면 탐지 기준은 단순히 “요청이 많았는가?”가 아닙니다.

> **어떤 API가 성공 응답을 반환했고, 그 응답에 외부로 나가면 안 되는 정보가 실제로 포함됐는가?**

#### ① 먼저 비공개 API를 민감 경로로 지정해야 한다

모든 응답에 같은 기준을 적용하면 정상적인 공개 정보에도 많은 이벤트가 발생할 수 있습니다.

따라서 다음과 같은 API를 우선 보호 대상으로 정의해야 합니다.

```text
/api/applicants/*
/api/evaluation/*
/api/idea/*
/api/admin/*
/api/internal/*
```

이 경로에서는 정상적인 `200 OK` 응답이라도 다음 필드가 외부로 반환되면 유출 이벤트로 처리해야 합니다.

| 구분 | 이번 사고에서 탐지해야 할 예 |
| --- | --- |
| 개인정보 | `email`, `name`, `phone`, `address` |
| 심사정보 | `review`, `evaluation`, `score`, `comment` |
| 창업 아이디어 | `ideaSummary`, `ideaContent`, `application` |
| 암호화 데이터 | `encryptedValue`, `cipherText`, `encryptedEmail` |
| 비밀정보 | `encryptionKey`, `secretKey`, `apiKey`, `accessToken`, `privateKey` |

필드명은 실제 애플리케이션의 JSON 스키마에 맞춰 사용자 정의 필터로 등록해야 합니다.

#### ② 개인정보 값과 업무 민감정보를 응답에서 직접 탐지한다

예를 들어 다음 응답이 외부 사용자에게 반환됐다면 요청 문자열에 공격 코드가 없어도 데이터 유출입니다.

```json
{
  "applicantId": 1001,
  "email": "user@example.com",
  "review": "시장성과 기술성이 우수함",
  "ideaSummary": "신규 창업 아이디어 요약"
}
```

이 경우 PLURA-WAF는 다음 정보를 하나의 이벤트로 남길 수 있습니다.

```text
Host / URI / Method
공격자 IP
HTTP 상태값: 200
응답 크기
유출정보: 이메일·심사평·아이디어 정보
응답 원본: Resp-body1
발생 시각
```

핵심은 “공격 요청이었는가”보다 **서버가 민감정보를 성공적으로 반환했는가**입니다.

#### ③ 암호키와 Secret은 개인정보와 별도 필터로 탐지해야 한다

후속 조사에서는 암호화된 데이터와 소스코드 형태의 암호키가 함께 노출된 사실이 확인됐습니다.

응답본문에 다음 문자열이나 구조가 포함되면 한 건만으로도 매우 높은 위험도로 처리해야 합니다.

```text
encryptionKey
secretKey
AES_KEY
API_KEY
accessToken
clientSecret
-----BEGIN PRIVATE KEY-----
-----BEGIN RSA PRIVATE KEY-----
```

예를 들어 다음과 같은 응답은 개인정보 값이 암호문이라도 위험합니다.

```json
{
  "encryptedEmail": "QmFzZTY0...ciphertext...",
  "encryptedReview": "A8F2...ciphertext...",
  "encryptionKey": "hard-coded-key-value"
}
```

이 이벤트는 단순한 개인정보 노출이 아니라 다음 의미를 가집니다.

```text
암호화 데이터 노출
        +
복호화 가능한 키 노출
        =
평문 복구가 가능한 Critical 유출
```

#### ④ 암호문만으로는 개인정보 정규식이 동작하지 않을 수 있다

이 부분이 매우 중요합니다.

암호화된 이메일이나 심사평은 일반적인 이메일·전화번호 정규식과 일치하지 않을 수 있습니다. 따라서 다음과 같은 방식이 추가로 필요합니다.

| 암호문 환경의 탐지 방법 | 설명 |
| --- | --- |
| JSON 필드명 탐지 | `encryptedEmail`, `encryptedReview` 등 금지 필드 확인 |
| API 응답 스키마 정책 | 외부 API에서 반환하면 안 되는 필드를 사전에 정의 |
| 암호키·Secret 탐지 | 복호화에 사용할 수 있는 값의 동반 노출 확인 |
| 응답 크기·건수 이상 | 평소보다 큰 응답이나 다수 객체 리스트 반환 확인 |
| 반복 성공 응답 | 서로 다른 객체에 대한 `200` 응답이 계속 발생하는지 분석 |
| 요청·응답 상관분석 | 객체 ID, Page Size, 계정, 세션과 유출 응답을 연결 |

따라서 “개인정보 패턴이 없으니 안전하다”는 판단은 잘못입니다.

> **암호화된 민감정보는 값의 모양이 아니라 API 경로, 필드명, 응답 스키마와 암호키 노출 여부로 탐지해야 합니다.**

#### ⑤ 응답 결과와 분산 호출 행위를 연결한다

39개 IP가 각각 임계치 이하로 호출했더라도, 같은 비공개 API에서 동일한 민감 필드가 계속 반환됐다면 전체적으로 하나의 수집 행위일 수 있습니다.

다음 조건을 연결해야 합니다.

```text
여러 IP가 동일 민감 API에 접근
        +
서로 다른 applicantId·page 값 사용
        +
200 성공 응답 반복
        +
응답마다 이메일·심사평·아이디어 필드 포함
        +
암호키 또는 Secret 노출
        =
분산 자동 수집에 의한 Critical 데이터 유출
```

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontFamily": "Pretendard, Noto Sans KR, Arial",
    "background": "#ffffff",
    "primaryTextColor": "#0f172a",
    "lineColor": "#1f2937"
  }
}}%%

flowchart LR
    A["🌐<br/><b>API 요청</b><br/>정상 형식"] --> B["🧱<br/><b>PLURA-WAF</b><br/>요청·응답 수집"]
    B --> C{"📄<br/><b>응답본문 분석</b>"}
    C -- "개인정보·심사평·아이디어" --> D["🚨<br/><b>데이터 유출 이벤트</b>"]
    C -- "암호키·Secret" --> E["🔥<br/><b>비밀정보 노출 이벤트</b>"]
    C -- "민감정보 없음" --> F["일반 응답"]
    D --> G["📊<br/><b>PLURA-XDR 상관분석</b>"]
    E --> G
    G --> H{"다수 IP·객체·세션<br/>반복 접근인가?"}
    H -- "예" --> I["🔥<br/><b>Critical 승격</b>"]
    H -- "아니오" --> J["🔎<br/><b>고위험 조사</b>"]
    I --> K["🧱<br/><b>후속 요청 차단</b><br/>IP·세션·토큰·API"]

    classDef normal fill:#eff6ff,stroke:#1e88e5,stroke-width:2px,color:#0f172a,font-weight:bold;
    classDef warn fill:#fff7ed,stroke:#f97316,stroke-width:2px,color:#0f172a,font-weight:bold;
    classDef danger fill:#ffe5e5,stroke:#d32f2f,stroke-width:2px,color:#0f172a,font-weight:bold;
    classDef critical fill:#fce7f3,stroke:#be185d,stroke-width:2px,color:#0f172a,font-weight:bold;
    classDef safe fill:#f0f9eb,stroke:#7cb342,stroke-width:2px,color:#0f172a,font-weight:bold;

    class A,F normal;
    class B,C,H warn;
    class D,J danger;
    class E,I critical;
    class G,K safe;
```

#### ⑥ 공개자료만으로 탐지 가능성을 확정할 수 없는 부분

후속 기사에는 암호키가 “API 내에 함께 있었다”고 설명돼 있지만, 다음 세부 구조는 공개되지 않았습니다.

* 암호키가 개인정보와 동일한 HTTP 응답에 포함됐는지
* 별도 API나 소스 파일을 통해 노출됐는지
* PLURA-WAF가 해당 API 트래픽을 실제로 통과·복호화해 볼 수 있었는지
* 응답이 압축되거나 검사하기 어려운 형식이었는지

따라서 다음과 같이 표현하는 것이 정확합니다.

> **해당 API 응답이 PLURA-WAF의 분석 경로를 통과했고, 데이터 유출 필터가 활성화돼 있으며, 응답본문을 해석할 수 있는 형식이었다면 개인정보·업무 민감정보·암호키 노출을 조기에 탐지할 수 있었을 가능성이 높습니다.**

반대로 암호키가 HTTP 응답이 아니라 서버 내부 소스 저장소에만 존재했다면 응답본문 분석만으로는 탐지할 수 없습니다. 이 경우에는 별도의 Secret Scanning, SAST, 저장소 점검이 필요합니다.

---

### 3-5. 분산 접근·응답본문·암호키를 함께 봐야 한다

이번 사건은 다음 세 가지를 동시에 분석해야 했습니다.

1. **행위**: 여러 IP에서 비공개 API가 반복 호출됐는가?
2. **결과**: 응답에 개인정보와 아이디어 정보가 포함됐는가?
3. **비밀정보**: 같은 응답 경로에 암호키나 토큰이 포함됐는가?

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontFamily": "Pretendard, Noto Sans KR, Arial",
    "background": "#ffffff",
    "primaryTextColor": "#0f172a",
    "lineColor": "#1f2937"
  },
  "themeCSS": "
    .node rect, .node circle, .node ellipse, .node polygon {
      filter: drop-shadow(0px 4px 8px rgba(15, 23, 42, 0.16));
    }
    .edgePath path { stroke-width: 2.6px; }
    .edgeLabel { background-color:#ffffff; color:#0f172a; font-weight:700; }
  "
}}%%

flowchart TD

    A["🌐<br/><b>다수 IP의 API 접근</b>"] --> B{"📈<br/><b>API·객체 기준<br/>분산 과요청?</b>"}
    B -- "예" --> C["🚨<br/><b>자동 수집 이벤트</b>"]
    B -- "아니오" --> D["일반 요청"]

    C --> E{"📄<br/><b>응답에 개인정보·<br/>아이디어 포함?</b>"}
    E -- "예" --> F["🚨<br/><b>민감정보 노출</b>"]
    E -- "아니오" --> G["⚠️<br/><b>자동화 접근</b>"]

    F --> H{"🔑<br/><b>암호키·토큰 등<br/>비밀정보 포함?</b>"}
    H -- "예" --> I["🔥<br/><b>Critical</b><br/>복호화·추가 악용 가능"]
    H -- "아니오" --> J["🚨<br/><b>High</b><br/>개인정보 유출"]

    I --> K["📊<br/><b>PLURA-XDR 상관분석</b>"]
    J --> K
    G --> K
    K --> L["🧱<br/><b>IP·세션·계정·API 차단</b>"]

    classDef normal fill:#eff6ff,stroke:#1e88e5,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef warn fill:#fff7ed,stroke:#f97316,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef danger fill:#ffe5e5,stroke:#d32f2f,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef critical fill:#fce7f3,stroke:#be185d,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef safe fill:#f0f9eb,stroke:#7cb342,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;

    class A,D normal;
    class B,E,H warn;
    class C,F,G,J danger;
    class I critical;
    class K,L safe;

    linkStyle 0,1,2,3,4,5,6,7,8,9,10,11 stroke:#1f2937,stroke-width:2.6px;
```

---

### 3-6. 암호화가 무력화된 이유: 데이터와 키를 함께 노출

후속 발표에서 가장 심각한 사실은 개인정보가 암호화돼 있었다는 점이 아니라, **암호키가 같은 API에 함께 포함돼 있었다는 점**입니다.

암호화의 목적은 데이터가 유출돼도 키를 가진 승인된 시스템만 평문으로 복원할 수 있게 하는 것입니다.

```text
암호화 데이터만 유출
→ 키가 없으면 즉시 평문 확인이 어려움

암호화 데이터 + 복호화 키 동반 유출
→ 공격자가 평문으로 복원 가능
```

이는 금고에 문서를 넣어 잠갔지만, 금고 열쇠를 같은 봉투에 넣어 외부로 전달한 것과 같습니다.

중요한 점은 공격자가 암호 알고리즘을 깨뜨린 것이 아니라는 사실입니다.

> **암호화는 깨진 것이 아니라, 키 관리 실패로 우회됐습니다.**

필요한 통제는 다음과 같습니다.

| 통제 | 설명 |
| --- | --- |
| 키와 데이터 분리 | API 응답·소스코드·DB와 암호키를 같은 경로에 두지 않음 |
| KMS/HSM 사용 | 키를 전용 관리 시스템에 저장하고 애플리케이션이 필요한 순간에만 사용 |
| 소스코드 비밀정보 금지 | 키·토큰·Secret을 코드와 설정 파일에 하드코딩하지 않음 |
| 키 접근 최소권한 | 서비스 계정별로 필요한 키와 작업만 허용 |
| 키 사용 감사 | 누가 언제 어떤 키로 복호화했는지 로그 기록 |
| 사고 후 즉시 회전 | 노출 가능성이 있는 키를 폐기·교체하고 영향 데이터를 재암호화 |
| 환경별 키 분리 | 개발·검증·운영 환경에서 동일 키를 사용하지 않음 |

WAF와 XDR은 응답에서 비밀정보 노출을 탐지하고 유출 흐름을 차단해야 하지만, 가장 먼저 해야 할 일은 **애플리케이션이 암호키를 API 응답에 포함하지 않도록 설계하는 것**입니다.

---

## 4) 왜 탐지하지 못했는가? 문제 제기

후속 발표로 이번 사건의 구조적 문제는 이전보다 명확해졌습니다.

| 후속 발표 내용 | 드러난 보안 문제 |
| --- | --- |
| API에 비공개 정보가 포함 | 응답 데이터 최소화와 권한 검증 부족 |
| 39개 국내 IP 접근 시도 | 분산 자동화 접근에 대한 상관분석 필요 |
| 웹 크롤링 방식 사용 | 봇·스크래핑·Enumeration 통제 부족 |
| 암호키가 API에 함께 존재 | 키와 데이터 분리 원칙 위반 |
| 모든 API 접근 로그 기록을 개선책으로 발표 | 기존 API 감사·추적 수준이 충분하지 않았을 가능성 |
| 신규 프로그램마다 외부 보안 검증 도입 | 개발·배포 전 보안 검증 체계가 충분하지 않았을 가능성 |
| 개인정보 보관기간·종류 정비 | 과도한 수집·장기 보관 문제 |
| 관리자 접근권한 재설계 | 최소권한 통제가 충분하지 않았을 가능성 |

정부가 발표한 개선책을 역으로 살펴보면 기존 통제가 어느 부분에서 부족했는지 추정할 수 있습니다. 다만 개선책을 발표했다는 사실만으로 기존 통제가 전혀 없었다고 단정해서는 안 됩니다.

이번 사건에서 가장 먼저 물어야 할 질문은 “WAF가 있었는가?” 하나가 아닙니다.

> **왜 비공개 API가 허가되지 않은 접근에 정보를 반환했는가?**  
> **왜 API 응답에 암호화 데이터와 복호화 가능한 암호키가 함께 있었는가?**  
> **왜 39개 IP의 유사 접근을 하나의 분산 수집 행위로 묶어 탐지하지 못했는가?**  
> **왜 개인정보와 아이디어 정보가 필요한 범위보다 많이 응답됐는가?**  
> **사고 직후 어떤 IP가 어떤 객체와 필드를 가져갔는지 즉시 재구성할 API 로그가 있었는가?**

WAF는 중요한 방어 계층이지만, 이번 사고는 **애플리케이션 권한 검증, 응답 최소화, 암호키 관리, API 로그, 자동화 접근 통제, XDR 상관분석**이 함께 실패했을 가능성을 보여 줍니다.

---

### 4-1. 가능성 1: WAF가 없었을 수 있다

API 서버가 인터넷에 직접 노출되어 있었다면, 공격자는 WAF를 거치지 않고 백엔드 API에 직접 접근할 수 있습니다.

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontFamily": "Pretendard, Noto Sans KR, Arial",
    "background": "#ffffff",
    "primaryTextColor": "#0f172a",
    "lineColor": "#1f2937"
  },
  "themeCSS": "
    .node rect, .node circle, .node ellipse, .node polygon {
      filter: drop-shadow(0px 4px 8px rgba(15, 23, 42, 0.16));
    }
    .edgePath path {
      stroke-width: 2.6px;
    }
    .edgeLabel {
      background-color: #ffffff;
      color: #0f172a;
      font-weight: 700;
    }
  "
}}%%

flowchart LR

    A["🤖<br/><b>AI 도구</b><br/>공격자"] --> B["🔌<br/><b>백엔드 API</b><br/>직접 노출"]
    B --> C["🗄️<br/><b>Database</b>"]
    C --> D["🚨<br/><b>개인정보 응답</b>"]
    D --> A

    classDef attacker fill:#fff1f2,stroke:#ef4444,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef normal fill:#eff6ff,stroke:#1e88e5,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef db fill:#eef9ff,stroke:#0288d1,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef danger fill:#ffe5e5,stroke:#d32f2f,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;

    class A attacker;
    class B normal;
    class C db;
    class D danger;

    linkStyle 0,1,2,3 stroke:#1f2937,stroke-width:2.6px;
```

이 경우에는 WAF 유무 이전에, **외부에 직접 노출된 API 자산 관리**가 핵심 문제가 됩니다.

---

### 4-2. 가능성 2: 웹은 WAF 뒤에 있었지만 API는 우회했을 수 있다

겉으로는 WAF를 사용 중이어도, 실제 개인정보가 나가는 API 도메인이 WAF 보호 대상이 아닐 수 있습니다.

```text
www.example.com → WAF 적용
api.example.com → WAF 미적용
admin-api.example.com → 직접 노출
```

이 경우 “WAF가 있었는가?”보다 중요한 질문은 다음입니다.

> **모든 API가 WAF 보호 경로 안에 있었는가?**

웹 페이지는 WAF 뒤에 있었지만, 모바일 앱 API, 관리자 API, 내부용 API, 구버전 API가 직접 노출되어 있었다면 공격자는 그 경로를 이용할 수 있습니다.

---

### 4-3. 가능성 3: 인라인 WAF 환경이었지만 Backend API 등록을 놓쳤을 수 있다

WAF가 있었다고 해서 모든 백엔드 API가 자동으로 보호되는 것은 아닙니다.

특히 인라인 WAF 환경에서는 트래픽이 물리적 또는 논리적으로 WAF 구간을 지나더라도, 실제 보호 정책은 등록된 서비스와 정책 범위에 따라 달라질 수 있습니다.

즉, 다음과 같은 상황이 가능합니다.

```text
WAF 장비는 존재함
트래픽도 WAF 구간을 통과함
하지만 Backend API 서비스, Host, URI, 정책, 응답본문 분석 대상 등록이 누락됨
결과적으로 일반 통과 또는 제한적 탐지만 수행
```

예를 들어 아래와 같은 구조입니다.

```text
www.example.com        → WAF 정책 적용
www.example.com/api/*  → 일부 정책만 적용
api.example.com        → Backend API 등록 누락
admin-api.example.com  → 별도 보호 정책 미적용
```

이 경우 인라인 WAF가 있어도 다음과 같은 탐지 공백이 생길 수 있습니다.

| 누락 가능성                | 결과                        |
| --------------------- | ------------------------- |
| Backend API 서비스 등록 누락 | API별 정책 적용 불가             |
| API Host 또는 URI 정책 누락 | `/api/*` 요청이 일반 웹 요청처럼 처리 |
| 응답본문 분석 비활성           | 개인정보 포함 응답 탐지 불가          |
| API 과요청 정책 미적용        | 반복 호출·순차 조회 탐지 불가         |
| TLS 복호화 미적용           | 요청·응답 본문 분석 불가            |
| JSON 응답 분석 미설정        | API 응답 내 민감정보 탐지 제한       |

따라서 “WAF가 있었는가?”라는 질문만으로는 부족합니다.

더 정확한 질문은 다음입니다.

> **WAF가 해당 Backend API를 실제 보호 대상으로 등록하고 있었는가?**
> **API 요청뿐 아니라 응답본문까지 분석하도록 설정되어 있었는가?**
> **API 과요청, 순차 ID 접근, 개인정보 응답 탐지 정책이 적용되어 있었는가?**

이번 사건에서도 인라인 WAF가 있었다면, 단순히 장비 유무만 볼 것이 아니라 **Backend API 등록 상태와 정책 적용 범위**를 반드시 확인해야 합니다.

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontFamily": "Pretendard, Noto Sans KR, Arial",
    "background": "#ffffff",
    "primaryTextColor": "#0f172a",
    "lineColor": "#1f2937"
  },
  "themeCSS": "
    .node rect, .node circle, .node ellipse, .node polygon {
      filter: drop-shadow(0px 4px 8px rgba(15, 23, 42, 0.16));
    }
    .edgePath path {
      stroke-width: 2.6px;
    }
    .edgeLabel {
      background-color: #ffffff;
      color: #0f172a;
      font-weight: 700;
    }
  "
}}%%

flowchart LR

    A["🤖<br/><b>공격자</b><br/>AI 도구"] --> B["🧱<br/><b>인라인 WAF</b><br/>트래픽 경유"]

    B --> C{"🔎<br/><b>Backend API<br/>보호 대상 등록?</b>"}

    C -- "등록됨" --> D["✅<br/><b>API 정책 적용</b><br/>과요청 / 응답본문 분석"]
    C -- "등록 누락" --> E["⚠️<br/><b>정책 미적용</b><br/>일반 통과 또는 제한 탐지"]

    D --> F["🔌<br/><b>백엔드 API</b>"]
    E --> F

    F --> G["📄<br/><b>응답본문</b><br/>개인정보 포함"]
    G --> H{"🔎<br/><b>응답본문 분석?</b>"}

    H -- "분석됨" --> I["🚨<br/><b>민감정보 탐지</b>"]
    H -- "분석 안 됨" --> J["⚠️<br/><b>유출 탐지 공백</b>"]

    I --> K["🧱<br/><b>차단 / 알림</b>"]
    J --> L["🚨<br/><b>정보 유출 지속</b>"]

    classDef attacker fill:#fff1f2,stroke:#ef4444,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef waf fill:#fff7ed,stroke:#f97316,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef normal fill:#eff6ff,stroke:#1e88e5,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef safe fill:#f0f9eb,stroke:#7cb342,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef danger fill:#ffe5e5,stroke:#d32f2f,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;

    class A attacker;
    class B,C,H waf;
    class F,G normal;
    class D,I,K safe;
    class E,J,L danger;

    linkStyle 0,1,2,3,4,5,6,7,8,9,10 stroke:#1f2937,stroke-width:2.6px;
```

---

### 4-4. 가능성 4: WAF가 있었지만 요청만 보고 정상으로 판단했을 수 있다

일반 WAF는 SQL Injection, XSS, 웹셸 업로드처럼 요청에 포함된 악성 문자열을 찾는 데 집중합니다.

하지만 API 정보 유출 요청은 다음처럼 보일 수 있습니다.

```http
GET /api/startups/1001
Authorization: Bearer 정상토큰
```

요청만 보면 정상입니다.

하지만 응답본문에는 개인정보가 포함될 수 있습니다.

```json
{
  "name": "홍길동",
  "phone": "010-1234-5678",
  "email": "user@example.com"
}
```

따라서 요청만 보는 WAF는 이 공격을 놓칠 수 있습니다.

이번 사건의 본질은 요청에 악성 문자열이 있었는지가 아닙니다.

> **정상처럼 보이는 요청의 결과로, 개인정보가 포함된 응답이 외부로 나갔는가?**

이것이 더 중요한 질문입니다.

---

### 4-5. 가능성 5: 분산 API 과요청을 IP별 정책으로만 봤을 수 있다

후속 조사에서는 39개 국내 IP가 비공개 API에 접근을 시도한 것으로 확인됐습니다.

이 구조에서는 IP별 요청 횟수만 보는 단순 Rate Limit이 충분하지 않을 수 있습니다.

```text
IP A: 임계치 이하
IP B: 임계치 이하
IP C: 임계치 이하
...
39개 IP 전체: 동일 API와 객체 범위 대량 조회
```

각 IP는 정상처럼 보이더라도 전체 행위는 하나의 자동 수집 캠페인일 수 있습니다.

따라서 다음 기준으로 묶어야 합니다.

* 동일 API와 URI 패턴
* 동일하거나 연속적인 객체 ID 범위
* 유사한 요청 헤더와 파라미터
* 동일 계정·토큰·세션 또는 연관 세션
* 비슷한 시간대와 호출 간격
* 동일한 개인정보 필드가 포함된 응답
* 동일한 암호키·토큰·비밀정보 노출

국내 IP라는 이유로 신뢰해서도 안 됩니다. 클라우드, 프록시, 감염 단말, 공유망을 이용하면 국내 IP에서도 자동화 공격이 발생할 수 있습니다.

---

### 4-6. 가능성 6: 호출 행위·응답 데이터·암호키를 상관분석하지 못했을 수 있다

이번 사건에서 가장 중요한 탐지 포인트는 세 가지입니다.

첫째, 여러 IP에서 비공개 API 접근이 반복됐는가?

둘째, 그 응답에 개인정보와 창업 아이디어가 포함됐는가?

셋째, 암호키·토큰과 같은 비밀정보가 같은 응답 경로로 노출됐는가?

각각을 별개 경보로 처리하면 사고의 심각성을 놓칠 수 있습니다.

```text
39개 IP의 유사 API 접근
        +
합격자 개인정보·심사평·아이디어 응답
        +
암호키 동반 노출
        =
복호화 가능한 대규모 정보 유출 Critical 이벤트
```

이 상관분석이 가능했다면 단순 웹 크롤링 경보가 아니라, 실제 데이터 유출과 암호체계 무력화가 결합된 최고 위험 이벤트로 즉시 승격할 수 있습니다.

---

## 5) PLURA-XDR에서 제공하는 대응 방안

PLURA-XDR 관점에서 이번 사건의 대응 핵심은 다음과 같습니다.

> **요청 문자열만 보지 말고 여러 IP에 분산된 API 호출 패턴을 봐야 합니다.**  
> **개인정보뿐 아니라 암호키·토큰·Secret 등 비밀정보가 응답으로 나가는지도 봐야 합니다.**  
> **IP별 임계치뿐 아니라 API·객체·계정·세션 기준으로 행위를 묶어야 합니다.**  
> **Backend API가 실제 보호 대상으로 등록돼 있는지 확인해야 합니다.**  
> **탐지 이후에는 IP 차단만이 아니라 세션·토큰·계정·API 단위로 대응해야 합니다.**

단, WAF와 XDR은 취약한 애플리케이션 설계를 대신할 수 없습니다. 객체 단위 권한 검증, API 응답 최소화, 암호키 분리와 같은 개발 단계의 통제가 먼저 적용돼야 합니다.

---

### 5-1. PLURA-WAF: 응답본문에서 실제 유출 데이터를 확인한다

PLURA 공식 문서에 따르면 웹 탐지 로그에는 요청본문과 응답본문이 포함되며, `유출정보`에서 응답본문에 포함된 기밀정보와 사용자 정보를 확인할 수 있습니다. 상태값과 응답 크기를 함께 볼 수 있고, 원본 로그의 `Resp-body1`에서 탐지된 응답 내용을 확인할 수 있습니다.

이번 사고에서는 다음 순서로 운영했어야 합니다.

#### 5-1-1. 데이터 유출 기능 활성화

PLURA 관리 화면에서 웹 데이터 유출 방지 필터를 활성화해야 합니다.

```text
관리
→ 사용
→ 웹
→ 데이터 유출
→ ON
```

기능이 꺼져 있다면 응답본문이 수집돼도 데이터 유출 이벤트로 분류되지 않을 수 있습니다.

#### 5-1-2. 모든 Backend API가 분석 경로를 통과하도록 구성

다음 조건이 먼저 충족돼야 합니다.

```text
api 도메인과 실제 Backend API가 PLURA-WAF 보호 대상에 등록
HTTPS 트래픽의 요청·응답본문 분석 가능
민감 API Host·URI가 예외 또는 우회 경로로 빠지지 않음
응답본문이 분석 가능한 형식과 인코딩으로 제공
```

PLURA 공식 FAQ는 응답본문 검사 시 MIME 타입, `Content-Encoding`, UTF-8 인코딩 조건을 확인하도록 안내합니다. 압축이나 인코딩 문제로 본문을 읽지 못하면 탐지 공백이 발생할 수 있으므로 운영 전 검증이 필요합니다.

* [PLURA 데이터유출 탐지 예외사항](https://docs.plura.io/ko/faq/siem/dfilter/breach)

#### 5-1-3. 이번 사고 전용 응답 필터 구성

이번 사건에 적용할 탐지 설계 예시는 다음과 같습니다.

| 규칙 | 조건 | 위험도 |
| --- | --- | --- |
| 합격자 개인정보 응답 | 민감 API + `200` + `email`·`phone` 등 포함 | High |
| 심사정보 응답 | 민감 API + `review`·`evaluation`·`score` 포함 | High |
| 창업 아이디어 응답 | 민감 API + `ideaSummary`·`application` 포함 | High |
| 암호화 데이터 응답 | 외부 API + `encrypted*` 필드 포함 | High |
| 암호키 노출 | `encryptionKey`·`secretKey`·Private Key 패턴 포함 | Critical |
| 데이터와 키 동반 노출 | 암호화 필드 + 키·Secret이 같은 응답 또는 동일 흐름에 존재 | Critical |
| 대량 객체 응답 | 민감 API + 비정상적으로 큰 응답 크기·객체 수 | High |
| 반복 유출 응답 | 여러 요청에서 동일 민감 필드가 반복 탐지 | Critical 후보 |

여기서 임계치는 모든 서비스에 동일하게 적용하는 것이 아니라 API별 정상 사용량과 응답 크기를 기준으로 조정해야 합니다.

#### 5-1-4. 이벤트에서 확인해야 할 증거

데이터 유출 이벤트가 생성되면 다음을 즉시 확인해야 합니다.

```text
공격자 IP
Host와 URI
HTTP Method
상태값
응답 크기
유출정보 종류
Resp-body1 원본
요청 파라미터와 객체 ID
계정·세션·토큰
동일 시각의 다른 IP 접근
```

이 정보가 있어야 “접근 시도”가 아니라 **어떤 데이터가 실제 응답으로 전달됐는지**를 설명할 수 있습니다.

#### 5-1-5. 탐지와 최초 유출 차단은 구분해야 한다

응답본문을 분석해 이벤트를 만드는 것과 첫 번째 응답이 클라이언트에 전달되기 전에 차단하는 것은 별개의 문제입니다.

응답 전달 전에 전체 본문을 검사·버퍼링하고 차단하는 정책이 적용되지 않았다면 최초 한 건은 외부에 전달될 수 있습니다. 그러나 최초 유출 이벤트를 기준으로 동일 IP·세션·토큰·API의 후속 호출을 즉시 차단하면 대량 수집으로 확대되는 것을 막을 수 있습니다.

따라서 현실적인 대응 목표는 다음과 같습니다.

> **첫 민감 응답에서 유출을 즉시 식별하고, PLURA-XDR 상관분석과 SOAR를 통해 이어지는 자동 수집을 중단시키는 것**

---

### 5-2. 분산 API 과요청과 자동화 접근 탐지

39개 IP 접근 정황은 단일 IP 임계치만으로 자동화 수집을 탐지해서는 안 된다는 점을 보여 줍니다.

PLURA-XDR은 다음 요소를 함께 분석해야 합니다.

| 분석 항목 | 의미 |
| --- | --- |
| 여러 IP의 동일 API 접근 | 분산 크롤링 또는 임계치 우회 가능성 |
| 객체 ID·페이지 범위 중복 | 여러 IP가 하나의 데이터 집합을 분담해 조회하는지 확인 |
| 동일 계정·토큰·세션 | IP가 달라도 같은 인증 주체인지 확인 |
| 유사한 헤더·파라미터 | 같은 도구나 스크립트의 군집 가능성 |
| 호출 시간과 간격 | 자동화된 일정 패턴 여부 |
| 응답의 민감정보 포함 | 실제 정보 수집 여부 |
| 암호키·Secret 포함 | 복호화 또는 추가 악용 가능성 |
| 국내 IP 여부 | 신뢰 근거가 아니라 참고 정보로만 사용 |

더 정확한 표현은 다음입니다.

> **이번 사건은 로그인 브루트포스로 확정할 수 없지만, 분산 API Enumeration·과요청·웹 크롤링 탐지와 응답본문 분석이 결합돼야 하는 사건입니다.**

---

### 5-3. Backend API 등록과 응답 스키마 점검

WAF가 인라인으로 구성되어 있더라도 Backend API가 보호 대상으로 등록되지 않거나 응답 스키마 정책이 없으면 정밀 탐지가 제한될 수 있습니다.

| 점검 항목 | 확인 내용 |
| --- | --- |
| 보호 도메인 등록 | `www`, `api`, `admin-api` 등 모든 실제 API 도메인이 등록돼 있는가 |
| Backend API 서비스 등록 | 개인정보를 반환하는 서버가 보호 대상으로 등록돼 있는가 |
| Host/URI 정책 | `/api/*`, `/v1/*`, `/admin/*` 등에 정책이 적용되는가 |
| TLS 복호화 | HTTPS 요청·응답본문을 분석할 수 있는가 |
| JSON 응답 스키마 | API별 허용 필드와 금지 필드가 정의돼 있는가 |
| 개인정보 탐지 | 이메일·전화번호·주소 등 민감정보 정책이 켜져 있는가 |
| 비밀정보 탐지 | 암호키·Token·Secret·Private Key가 응답에 포함되는지 탐지하는가 |
| 분산 과요청 탐지 | 여러 IP를 API·객체·계정 기준으로 묶는가 |
| 차단 정책 | IP뿐 아니라 세션·토큰·계정·API 차단이 가능한가 |

이 점검은 단순 장비 유무 확인이 아닙니다.

> **WAF가 있는가가 아니라, WAF가 해당 API의 요청과 응답을 실제로 보고 있으며 허용 가능한 응답 스키마까지 이해하고 있는가를 확인해야 합니다.**

---

### 5-4. PLURA-XDR 상관분석: 단일 응답을 사고 흐름으로 전환한다

응답본문 탐지만으로는 한 건의 민감정보 노출을 확인할 수 있습니다.

PLURA-XDR의 역할은 이 이벤트를 다른 행위와 연결해 **실수성 단건 노출인지, 자동화된 대량 유출인지** 판단하는 것입니다.

#### 5-4-1. 상관분석에 연결할 신호

```text
PLURA-WAF 요청·응답 로그
데이터 유출 탐지 이벤트
유출정보 종류
Resp-body1 원본
HTTP 상태값과 응답 크기
API URI·객체 ID·Page Size
계정·세션·토큰 사용 정보
다수 IP의 유사 접근
User-Agent·Referer·Cookie 등 헤더 패턴
서버·애플리케이션·DB 감사 로그
Backend API 보호 정책 상태
```

#### 5-4-2. 이번 사고에 적용할 상관 시나리오

| 단계 | 탐지 신호 | 해석 |
| --- | --- | --- |
| 1 | 비공개 API에서 `200` 응답 | 접근이 실제로 성공했을 가능성 |
| 2 | 응답본문에서 이메일·심사평·아이디어 탐지 | 실제 민감정보 반환 확인 |
| 3 | 서로 다른 객체 ID 또는 페이지가 연속 조회 | 자동 수집 또는 Enumeration 가능성 |
| 4 | 여러 IP에서 동일 API·응답 스키마 반복 | 분산 크롤링 가능성 |
| 5 | 암호키·Secret 탐지 | 복호화 또는 추가 침해 가능성 |
| 6 | 암호화 데이터와 키가 동일 흐름에서 확인 | Critical 유출로 승격 |
| 7 | 후속 요청 지속 | 자동 차단 및 사고대응 가동 |

이를 문장으로 재구성하면 다음과 같습니다.

```text
서로 다른 여러 IP가 비공개 합격자 API를 호출했다.
각 요청은 정상 형식이었고 서버는 200으로 응답했다.
응답본문에는 이메일, 심사평, 창업 아이디어 필드가 반복 포함됐다.
객체 ID 또는 페이지 범위가 계속 변경되며 다수 합격자 정보가 반환됐다.
같은 응답 흐름에서 암호키 또는 Secret도 확인됐다.
따라서 단순 크롤링이 아니라 복호화 가능한 민감정보의 자동 수집으로 판단한다.
```

#### 5-4-3. 위험도 승격 기준

| 탐지 조합 | 권고 판단 |
| --- | --- |
| 민감 API 접근만 발생 | 관찰 또는 Middle |
| 민감정보 포함 성공 응답 1건 | High |
| 여러 객체에 민감정보 응답 반복 | Very High |
| 여러 IP에 분산된 반복 유출 | Very High |
| 암호키·Private Key·Token 노출 | Critical |
| 암호화 데이터와 복호화 키 동반 노출 | Critical |
| Critical 이벤트 이후 후속 요청 지속 | 즉시 자동 대응 |

국내 IP이거나 TI 점수가 낮다는 이유로 정상 처리해서는 안 됩니다. 이번 유형은 IP 평판보다 **응답으로 무엇이 전달됐는지**가 더 강한 증거입니다.

PLURA-XDR의 상관분석 흐름은 다음과 같습니다.

```text
민감 API의 200 응답
→ 응답본문 유출정보 탐지
→ 객체 ID·Page 범위 변화 확인
→ 다수 IP·계정·세션 연결
→ 암호키·Secret 동반 노출 확인
→ Critical 사고 승격
→ IP·세션·토큰·계정·API 후속 차단
```

---

### 5-5. 자동 차단

39개 IP에 접근이 분산된 상황에서는 IP 하나만 차단하는 방식으로 충분하지 않을 수 있습니다.

예를 들어 다음 조건을 조합할 수 있습니다.

```text
여러 IP에서 동일 민감 API 반복 호출
여러 IP가 연속·중복 객체 ID 범위 조회
동일 계정·토큰·세션이 여러 IP에서 사용
개인정보 포함 응답이 일정 횟수 이상 발생
암호키·Token·Secret이 응답에서 한 번이라도 탐지
API 과요청 + 개인정보 응답 + 비밀정보 노출 동시 발생
```

| 대응 방식 | 설명 |
| --- | --- |
| IP·대역 임시 차단 | 명백한 자동화 접근의 출발지 통제 |
| 세션 종료 | 로그인 세션 강제 폐기 |
| 토큰 무효화 | 의심 Access Token·API Key 폐기 |
| 계정 잠금·추가 인증 | 비정상 조회 계정 보호 |
| API별 Rate Limit 강화 | 공격 대상 API에 즉시 강화 정책 적용 |
| 응답 필드 차단·마스킹 | 민감 필드와 비밀정보 외부 반환 중단 |
| 암호키 회전 | 노출된 키 폐기, 신규 키 발급 및 재암호화 |
| 증거 보존 | 요청·응답·세션·DB 로그를 원본으로 보존 |

암호키가 노출된 경우에는 네트워크 차단만으로 사고 대응이 끝나지 않습니다. 해당 키를 즉시 폐기·교체하고, 그 키로 보호된 데이터 전체의 영향 범위를 검토해야 합니다.

---

### 5-6. 어떻게 방어해야 하는가?

이번 사고는 단일 제품이나 단일 정책만으로 해결되지 않습니다.

| 구분 | 대응 항목 | 설명 |
| --- | --- | --- |
| 애플리케이션 | Object Level Authorization | 사용자가 요청한 객체에 접근할 권한이 있는지 서버에서 매번 검증 |
| 애플리케이션 | Response Minimization | API에 필요한 필드만 반환하고 심사평·아이디어 등은 목적별 분리 |
| 애플리케이션 | Response Scrubbing | 불필요한 민감정보와 내부 필드 제거·마스킹 |
| 비밀관리 | 키와 데이터 분리 | 암호키를 API 응답·소스코드·DB 데이터와 분리 |
| 비밀관리 | KMS/HSM 및 키 회전 | 전용 키 관리, 최소권한, 감사, 노출 시 즉시 교체 |
| 개발보안 | Secret Scanning | 소스코드와 배포 산출물의 하드코딩 키·토큰 검사 |
| API 보안 | Rate Limiting | IP뿐 아니라 계정·세션·API·객체 범위별 호출 제한 |
| API 보안 | 분산 Enumeration 탐지 | 여러 IP가 동일 데이터 범위를 나눠 조회하는 패턴 탐지 |
| API 보안 | Page Size·검색범위 제한 | 한 번에 반환되는 데이터 양 제한 |
| WAF | Backend API 보호 등록 | 실제 API 도메인·Host·URI를 빠짐없이 보호 |
| WAF | 응답본문 분석 | 개인정보·아이디어 정보·암호키·Token 노출 탐지 |
| XDR | 다중 신호 상관분석 | IP·계정·세션·객체·응답·비밀정보를 연결 |
| SOAR | 자동 대응 | IP·세션·계정·토큰·API 차단과 키 회전 절차 연계 |
| 감사/조사 | 모든 API 접근 로그 | 요청 주체, 객체, 응답 필드, 결과를 원본으로 보존 |

정리하면 핵심은 다음 일곱 가지입니다.

> **권한 검증으로 막고,  
> API 응답을 최소화하고,  
> 데이터와 암호키를 분리하고,  
> 분산 자동화 접근을 조기에 탐지하고,  
> 응답본문에서 개인정보와 비밀정보 노출을 확증하고,  
> XDR 상관분석으로 사고를 판단하고,  
> SOAR로 차단·토큰 폐기·키 회전까지 연결해야 합니다.**

---

### 5-7. PLURA-XDR 대응 구조

```mermaid
%%{init: {
  "theme": "base",
  "themeVariables": {
    "fontFamily": "Pretendard, Noto Sans KR, Arial",
    "background": "#ffffff",
    "primaryTextColor": "#0f172a",
    "lineColor": "#1f2937"
  },
  "themeCSS": "
    .node rect, .node circle, .node ellipse, .node polygon {
      filter: drop-shadow(0px 4px 8px rgba(15, 23, 42, 0.16));
    }
    .edgePath path {
      stroke-width: 2.6px;
    }
    .edgeLabel {
      background-color: #ffffff;
      color: #0f172a;
      font-weight: 700;
    }
    .cluster rect {
      rx: 18px;
      ry: 18px;
      filter: drop-shadow(0px 6px 12px rgba(15, 23, 42, 0.14));
    }
    .cluster-label {
      font-size: 21px;
      font-weight: 800;
    }
  "
}}%%

flowchart LR

    USER(["👤<br/><b>사용자 / 공격자</b>"])

    subgraph PUBLIC["공개 구간"]
        direction LR
        WAF["🧱<br/><b>PLURA-WAF</b><br/>요청·응답 분석"]
        API["🔌<br/><b>백엔드 API</b>"]
    end

    subgraph DETECTION["탐지 영역"]
        direction TB
        REQ["🌐<br/><b>요청 분석</b><br/>URI / 메서드 / 파라미터"]
        BRUTE["📈<br/><b>API 브루트포스</b><br/>과요청 탐지"]
        RESP["📄<br/><b>응답본문 분석</b><br/>개인정보 / 민감정보"]
        BEHAVIOR["🧭<br/><b>행위 분석</b><br/>IP / 계정 / 세션"]
        POLICY["🔎<br/><b>API 정책 확인</b><br/>Backend API 등록 / URI 정책"]
    end

    subgraph XDR["PLURA-XDR"]
        direction TB
        SIEM["📊<br/><b>PLURA-SIEM</b><br/>로그 상관분석"]
        SOAR["⚙️<br/><b>SOAR</b><br/>자동 대응"]
        BLOCK["🧱<br/><b>자동 차단</b><br/>IP / 세션 / 계정 / 토큰"]
    end

    DB["🗄️<br/><b>데이터베이스</b>"]

    USER --> WAF
    WAF --> API
    API --> DB
    DB --> API
    API --> WAF

    WAF -. "요청 로그" .-> REQ
    WAF -. "API 과요청 이벤트" .-> BRUTE
    WAF -. "응답본문 이벤트" .-> RESP
    WAF -. "트래픽 패턴" .-> BEHAVIOR
    WAF -. "정책 적용 상태" .-> POLICY

    REQ --> SIEM
    BRUTE --> SIEM
    RESP --> SIEM
    BEHAVIOR --> SIEM
    POLICY --> SIEM

    SIEM --> SOAR
    SOAR --> BLOCK
    BLOCK -. "비정상 접근 차단" .-> WAF

    classDef user fill:#eff6ff,stroke:#1e88e5,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef public fill:#f0f9eb,stroke:#7cb342,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef detection fill:#fff7ed,stroke:#f97316,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef xdr fill:#ecfeff,stroke:#00acc1,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef security fill:#fff1f2,stroke:#ef4444,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;
    classDef db fill:#eef9ff,stroke:#0288d1,stroke-width:2px,color:#0f172a,font-size:18px,font-weight:bold;

    class USER user;
    class WAF security;
    class API public;
    class DB db;
    class REQ,BRUTE,RESP,BEHAVIOR,POLICY detection;
    class SIEM,SOAR,BLOCK xdr;

    style PUBLIC fill:#f7fbf3,stroke:#7cb342,stroke-width:2px,color:#33691e;
    style DETECTION fill:#fffaf2,stroke:#f97316,stroke-width:2px,color:#9a3412;
    style XDR fill:#ecfeff,stroke:#00acc1,stroke-width:2px,color:#0e7490;

    linkStyle 0,1,2,3,4 stroke:#1f2937,stroke-width:2.6px;
    linkStyle 5,6,7,8,9,10,11,12,13,14,15,16 stroke:#0891b2,stroke-width:2.3px,stroke-dasharray:6 4;
```

---

### 5-8. 운영 기준 예시

실제 운영에서는 응답본문 탐지와 호출 행위를 다음과 같이 조합할 수 있습니다.

| 탐지 조건 | 의미 | 대응 |
| --- | --- | --- |
| 민감 API + `200` + 금지 필드 포함 | 외부 반환이 허용되지 않은 데이터 확인 | High 이벤트·담당자 통보 |
| `email`·`review`·`ideaSummary` 반복 탐지 | 실제 개인정보·업무정보 수집 가능성 | Very High 승격 |
| 암호화 필드만 포함 | 값 기반 개인정보 탐지 한계 | API·필드명·응답 크기 기준 추가 분석 |
| `encryptionKey`·`secretKey`·Private Key 노출 | 암호체계 또는 인증체계 무력화 가능성 | Critical·즉시 차단·키 회전 |
| 암호화 데이터와 키가 같은 응답에 존재 | 즉시 복호화 가능한 데이터 유출 | Critical 사고대응 |
| 여러 IP가 동일 API·객체 범위를 조회 | 분산 웹 크롤링 가능성 | API·객체 기준 상관분석 |
| 객체 ID·페이지 값이 연속 변경 | API Enumeration 가능성 | 후속 요청 차단 |
| 동일 계정·토큰이 여러 IP에서 사용 | 인증정보 공유·탈취 가능성 | 세션 종료·토큰 무효화 |
| 정상 대비 응답 크기 급증 | 대량 객체 또는 과도한 필드 반환 가능성 | 응답 원본 조사·Rate Limit 강화 |
| 최초 유출 이벤트 이후 호출 지속 | 자동 수집 진행 중 | SOAR 자동 차단 |
| 본문 해석 실패 | 압축·MIME·인코딩에 따른 탐지 공백 | 수집·복호화·인코딩 설정 점검 |

운영 정책에서 가장 중요한 우선순위는 다음과 같습니다.

```text
1. 암호키·Private Key·Token 노출은 횟수와 관계없이 Critical
2. 민감정보를 포함한 성공 응답은 요청 문자열이 정상이어도 High
3. 여러 객체 또는 여러 IP에서 반복되면 대량 유출로 승격
4. 암호문은 개인정보 정규식만 믿지 말고 필드명과 API 스키마로 탐지
5. 최초 이벤트 이후 후속 요청을 즉시 차단
```

> **Backend API 보호 상태, 응답본문의 실제 유출정보, 암호키·Secret, 객체 ID 변화, 응답 크기, 다수 IP와 계정·세션 행위를 함께 봐야 합니다.**

---

## 결론

7월 31일 후속 발표는 이번 사건의 본질을 더욱 분명하게 만들었습니다.

```text
39개 국내 IP의 비공개 API 접근 시도
        +
웹 크롤링을 이용한 자동 수집
        +
합격자 5천 명의 이메일·심사평·아이디어 요약 유출
        +
암호화 데이터와 암호키 동반 노출
        =
복호화 가능한 API 정보 유출 사고
```

따라서 핵심은 “AI 도구를 사용했는가”가 아닙니다.

웹 크롤링 사용은 확인됐지만 특정 AI 솔루션 업체와 접근 주체의 관계는 경찰 수사 중입니다. AI라는 표현을 앞세우면 오히려 서버 측의 본질적인 실패가 흐려질 수 있습니다.

진짜 문제는 다음입니다.

> **비공개 API가 허가되지 않은 접근에 민감정보를 반환했고, 자동 수집을 막지 못했으며, 암호화 데이터와 이를 풀 수 있는 암호키까지 같은 노출 경로에 포함했습니다.**

이번 사건이 던지는 질문은 명확합니다.

> **우리의 API는 객체별 권한을 검증하는가?**  
> **응답에는 업무에 필요한 최소 정보만 포함되는가?**  
> **암호키와 토큰은 소스코드·API 응답과 완전히 분리돼 있는가?**  
> **여러 IP에 분산된 자동 수집을 하나의 행위로 묶어 탐지할 수 있는가?**  
> **개인정보뿐 아니라 암호키·Secret이 외부로 나가는 순간을 탐지할 수 있는가?**  
> **사고 후 어느 IP가 어느 데이터를 가져갔는지 원본 로그로 재구성할 수 있는가?**  
> **탐지 후 세션·토큰·계정·API 차단과 키 회전까지 자동으로 연결할 수 있는가?**

PLURA-XDR의 대응 방향은 다음과 같습니다.

> **PLURA-WAF는 Backend API의 응답본문에서 실제 외부로 전달된 개인정보·업무 민감정보와 암호키·Token·Secret을 `유출정보`로 탐지하고, 상태값·응답 크기·`Resp-body1` 원본을 근거로 제공합니다. PLURA-XDR은 이 유출 이벤트를 IP·계정·세션·객체·페이지 범위와 상관분석해 대량 수집 여부를 판단하고 후속 요청 차단으로 연결합니다.**

그러나 보안 제품만으로 잘못 설계된 API를 완전히 보완할 수는 없습니다.

가장 먼저 해야 할 일은 서버가 권한 없는 데이터를 반환하지 않도록 만들고, API 응답을 최소화하며, 암호키를 데이터와 분리하는 것입니다.

정리하면 이번 사건은 이렇게 말할 수 있습니다.

> **AI가 개인정보를 뚫은 사건이 아닙니다.  
> 웹 크롤링이 취약한 백엔드 API를 반복 호출했고,  
> 서버는 개인정보와 창업 아이디어뿐 아니라 암호키까지 반환했습니다.  
> 암호화는 공격자가 깬 것이 아니라, 키 관리 실패로 무력화됐습니다.**

**요청만 보는 보안으로는 부족합니다. API의 행위, 응답 데이터, 비밀정보 노출까지 함께 봐야 합니다.**

---

## 📚 함께 읽기

* [쿠팡 등 API 인증 키(JWT) 유출 사고](https://blog.plura.io/ko/threats/case-coupang_authkey/)

## 📖 관련 기사 및 공식 자료

* [PLURA-XDR 데이터유출](https://docs.plura.io/ko/v6/fn/comm/sdetection/databreach)
* [PLURA 웹 필터탐지 – 요청·응답본문 및 유출정보](https://docs.plura.io/ko/fn/waf/detection)
* [PLURA 데이터유출 탐지 예외사항 – MIME·압축·UTF-8](https://docs.plura.io/ko/faq/siem/dfilter/breach)
* [‘모두의창업’ 정보 유출 원인은 “AI 도구로 백엔드 API에 비정상 접근” – 바이라인네트워크](https://byline.network/2026/06/22-573/)
* [중기부, 「모두의 창업」 개인정보 유출 사안 설명자료 – 2026년 6월 18일](https://www.mss.go.kr/site/smba/ex/bbs/View.do?bcIdx=1069139&cbIdx=87)
* [개인정보에 ‘암호키’도 유출…중기부, ‘모두의 창업’ 보안 강화 – 연합뉴스, 2026년 7월 31일](https://v.daum.net/v/20260731120741561)
