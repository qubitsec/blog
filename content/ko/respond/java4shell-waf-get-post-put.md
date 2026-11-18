---
title: "Java4Shell WAF 대응: GET·POST·PUT 요청에서 무엇을 차단해야 하는가"
date: 2026-11-19
lastmod: 2026-11-19
draft: false
description: "NGINX와 ModSecurity를 기준으로 Java4Shell의 HTTP 메서드별 검사 위치, Base64 탐지식, 본문 파서, 동기 차단과 검증 방법을 설명합니다."
featured_image: "/cdn/respond/java4shell-waf-get-post-put.png"
tags: ["Java4Shell", "CVE-2026-114938", "Java", "웹방화벽", "WAF", "ModSecurity", "NGINX", "가상 패치", "PLURA-WAF"]
---

### 🛡️ Java가 디코딩하기 전에 차단해야 합니다

**Java4Shell 대응의 핵심은 외부에서 들어온 비정상 Base64 값이 취약한 Java 디코더에 도달하기 전에 차단하는 것입니다.** 웹방화벽에서 보호할 HTTP 경로와 검사 대상을 구체화하고, 실제 차단 효과를 확인하면서 Java 패치를 병행해야 합니다.

2026년 11월 17일 공개된 **Java4Shell**(CVE-2026-114938)은 Java의 하드웨어 가속 Base64 디코딩 경로에서 발생하는 메모리 손상 취약점입니다. 취약 코드가 포함된 미수정 런타임에서 **x86-64의 AVX-512 VBMI 가속 경로**가 사용되고, 공격자가 제어한 입력이 해당 디코더에 도달하는 조건이 맞으면 정보 노출·서비스 장애·원격 코드 실행으로 이어질 수 있습니다.[^microsoft][^calif]

운영자에게 필요한 것은 “Base64를 검사한다”는 설명을 실제 정책으로 바꾸는 기준입니다. **어느 HTTP 메서드에서, 어느 위치의 값을, 어떻게 파싱하고, 언제 거부할 것인지**가 정해져야 WAF에 규칙을 넣을 수 있습니다.

| No. | 결정할 항목 | 적용 기준 |
| --- | --- | --- |
| 1 | HTTP 메서드 | 서비스가 허용하는 모든 메서드에 검사 적용 |
| 2 | 요청 위치 | 헤더·쿠키·쿼리·경로와 요청 본문 |
| 3 | 본문 해석 | Content-Type에 맞는 파서로 개별 값 추출 |
| 4 | 차단 조건 | 알려진 비정상 패딩과 지정 Base64 필드의 문법 위반 |
| 5 | 차단 시점 | 원본 Java 서버에 요청을 전달하기 전 |
| 6 | 검사 실패 | 파싱 실패·검사 한도 초과를 정상 통과로 처리하지 않음 |
| 7 | 근본 조치 | 실행 중인 Java 런타임의 보안 업데이트 |

<!--more-->

> **WAF에서 공격 입력을 통제하고, 보호가 확인된 서비스를 운영하면서 Java 패치를 진행합니다.**
> 이때 보호 여부는 규칙 등록 화면이 아니라 **실제 검사 결과와 원본 서버 미도달**로 확인해야 합니다.

---

### 🔎 GET·POST·PUT은 어디를 검사해야 할까요?

같은 `payload` 값도 쿼리, 폼, JSON 등 서로 다른 위치로 전달될 수 있습니다. WAF는 요청의 전송 형식을 해석한 다음 애플리케이션이 사용할 값을 검사해야 합니다.

아래는 **NGINX + libModSecurity v3** 기준의 검사 위치입니다. `phase:1`은 요청 헤더를 읽은 단계, `phase:2`는 본문을 읽은 뒤의 단계입니다.[^phases]

| No. | 요청 형태 | 검사 대상 | 시점 |
| --- | --- | --- | --- |
| 1 | `GET /api?payload=...` | `ARGS_GET`, `REQUEST_HEADERS`, `REQUEST_COOKIES` | phase 1 |
| 2 | `POST /api?payload=...` | POST에 포함된 쿼리도 `ARGS_GET`으로 검사 | phase 1 |
| 3 | `POST` + 폼·JSON 본문 | 파싱된 개별 값 `ARGS` | phase 2 |
| 4 | `PUT` + 폼·JSON 본문 | POST와 같은 `ARGS` | phase 2 |
| 5 | `PATCH` + 폼·JSON 본문 | POST와 같은 `ARGS` | phase 2 |
| 6 | `DELETE`, `HEAD`, `OPTIONS` | 헤더·쿠키·쿼리 검사. 허용된 본문이 있으면 추가 검사 | phase 1·2 |
| 7 | 본문이 포함된 `GET` | 헤더·쿠키·쿼리와 본문을 각각 검사 | phase 1·2 |
| 8 | 모든 메서드의 `/api/<Base64url 값>` | 경로 세그먼트에 담긴 값 | phase 1 |

**본문 검사 규칙에는 `POST` 메서드 조건을 붙이지 않습니다.** PUT·PATCH도 같은 JSON·폼 입력을 받을 수 있기 때문입니다. 지원하지 않는 메서드나 본문은 해당 API의 허용 정책에 따라 거부하면 됩니다.

또한 `ARGS_GET`·`ARGS_POST`의 이름과 HTTP 메서드를 구분해야 합니다. 쿼리는 POST 요청에도 `ARGS_GET`으로 들어가고, 폼 본문의 처리는 PUT·PATCH에도 적용됩니다. JSON까지 포함하는 본문 검사에는 `ARGS`를 사용합니다.[^transaction]

---

### 🧩 Content-Type을 해석한 뒤 개별 값을 검사합니다

본문 전체에서 문자열을 검색하는 것과, JSON·폼을 파싱한 뒤 값을 검사하는 것은 결과가 다릅니다. 예를 들어 JSON의 `\u003d`는 파싱 후 `=`가 됩니다. Java에 전달되는 값과 같은 표현을 검사하려면 해당 파서가 먼저 동작해야 합니다.

| No. | Content-Type | 본문 처리 | 검사 변수 |
| --- | --- | --- | --- |
| 1 | `application/x-www-form-urlencoded` | URLENCODED 파서가 이름과 값 분리 | `ARGS` |
| 2 | `application/json`, `application/*+json` | JSON 파서가 문자열 값 추출 | `ARGS` |
| 3 | `multipart/form-data` | multipart 파서가 일반 필드 추출 | `ARGS` |
| 4 | `application/xml`, `text/xml`, `application/*+xml` | XML 텍스트와 속성 값 추출 | `XML://text()`, `XML://@*` |
| 5 | 원시 본문 | 알려진 패턴 보조 검색 | `REQUEST_BODY` |

URLENCODED·MULTIPART는 Content-Type에 따라 자동 선택됩니다. JSON·XML은 phase 1에서 프로세서를 지정해야 합니다. multipart의 **일반 필드**와 **업로드 파일 내부**도 구분해야 합니다. 파일 안의 압축 데이터나 별도 포맷까지 `ARGS`에서 해석되는 것은 아닙니다.[^variables]

#### JSON·XML 파서 선택 예제

아래 코드는 제공한 전체 설정의 발췌입니다. 실제 적용에는 뒤에서 설명하는 검사 한도·오류 처리 규칙도 함께 필요합니다.

```apache
SecRuleEngine On
SecRequestBodyAccess On

SecRule REQUEST_HEADERS:Content-Type "@rx ^application/(?:[a-z0-9.+_-]+\+)?json(?:[ \t]*;|[ \t]*$)" \
    "id:11901,phase:1,t:none,t:lowercase,pass,nolog,ctl:requestBodyProcessor=JSON"

SecRule REQUEST_HEADERS:Content-Type "@rx ^(?:(?:application|text)/xml|application/[a-z0-9.+_-]+\+xml)(?:[ \t]*;|[ \t]*$)" \
    "id:11902,phase:1,t:none,t:lowercase,pass,nolog,ctl:requestBodyProcessor=XML"
```

`Content-Type: application/json`이라는 헤더가 있다는 사실만으로 JSON 검사 완료를 판단하면 안 됩니다. 배포된 엔진의 JSON·XML 지원과 실제 파싱된 변수를 확인해야 합니다.

---

### 🧬 어떤 Base64를 차단해야 할까요?

정상 Base64에도 끝의 `=`나 `==`가 사용됩니다. 따라서 **`=`가 있다는 이유만으로 차단하지 않습니다.** 문자 개수, 마지막 단위, 패딩 위치와 개수를 함께 검사해야 합니다. Java 디코더는 일부 정상 입력의 패딩 생략도 허용하므로 서비스가 허용하는 문법을 먼저 정해야 합니다.[^decoder]

Calif의 분석은 64개 단위 처리 후 남는 입력에서 다음과 같은 비정상 꼬리가 문제가 될 수 있음을 설명합니다. `X`, `Y`는 데이터 문자이며, 아래는 전체 공격 문자열의 종류가 아니라 **마지막 꼬리의 형태**입니다.[^calif]

| No. | 비정상 꼬리 | 공통 탐지식에 포함 |
| --- | --- | --- |
| 1 | `=` | 포함 |
| 2 | `==` | 포함 |
| 3 | `X=` | 포함 |
| 4 | `X==` | 포함 |
| 5 | `XY=` | 포함 |
| 6 | `===` | 포함 |

WAF 정책은 두 단계로 구성합니다.

1. **공통 패턴 검사:** 여러 입력 위치에서 공개된 비정상 패딩 패턴을 찾습니다.
2. **지정 필드 문법 검사:** Base64를 받는 API와 필드가 확인되면 정상 문법을 벗어난 값 전체를 거부합니다.

Microsoft도 헤더·쿼리·본문 등 입력 위치에 따른 WAF 규칙을 공개했습니다. 아래 SecRule은 공개 자료를 바탕으로 구성한 참조 구현이며, 특정 공급자가 배포한 제품 규칙을 그대로 옮긴 것은 아닙니다.[^microsoft]

---

### ⚙️ 공통 규칙: 헤더·쿠키·쿼리와 본문을 검사합니다

#### ① 모든 메서드의 헤더·쿠키·쿼리

```apache
SecRule REQUEST_HEADERS|REQUEST_COOKIES|ARGS_GET "@rx (?:\A|[^A-Za-z0-9+/_=-])(?:[A-Za-z0-9+/_-]{64})+(?:[A-Za-z0-9+/_-]{0,2}=|[A-Za-z0-9+/_-]?==|===)(?=\z|[^A-Za-z0-9+/_=-])" \
    "id:11910,phase:1,t:none,deny,status:403,log,msg:'Java4Shell known malformed Base64 token in headers cookies or query',tag:'CVE-2026-114938'"
```

GET 쿼리, POST에 붙은 쿼리, Authorization 헤더와 쿠키 값 등에서 해당 패턴을 찾으면 요청 전체를 403으로 거부합니다. 쿠키와 쿼리는 원시 `이름=값` 문자열만 검색하지 않고 **파싱된 값**도 검사합니다.

#### ② POST·PUT·PATCH의 JSON·폼 본문

```apache
SecRule ARGS "@rx (?:\A|[^A-Za-z0-9+/_=-])(?:[A-Za-z0-9+/_-]{64})+(?:[A-Za-z0-9+/_-]{0,2}=|[A-Za-z0-9+/_-]?==|===)(?=\z|[^A-Za-z0-9+/_=-])" \
    "id:11930,phase:2,t:none,deny,status:403,log,msg:'Java4Shell known malformed Base64 token in parsed arguments',tag:'CVE-2026-114938'"
```

**이 규칙에는 메서드 조건이 없습니다.** 앞에서 선택한 파서가 JSON·폼·multipart 일반 필드의 값을 `ARGS`에 넣으면 같은 규칙이 적용됩니다. 허용된 GET 본문도 같은 처리 대상입니다.

#### ③ URL 경로와 XML

경로에 들어가는 Base64url과 XML 값은 대상 변수를 따로 지정합니다.

```apache
SecRule REQUEST_FILENAME "@rx (?:\A|/)(?:[A-Za-z0-9_-]{64})+(?:[A-Za-z0-9_-]{0,2}=|[A-Za-z0-9_-]?==|===)(?=/|\z)" \
    "id:11911,phase:1,t:none,deny,status:403,log,msg:'Java4Shell known malformed Base64url path segment',tag:'CVE-2026-114938'"

SecRule XML://text()|XML://@* "@rx (?:\A|[^A-Za-z0-9+/_=-])(?:[A-Za-z0-9+/_-]{64})+(?:[A-Za-z0-9+/_-]{0,2}=|[A-Za-z0-9+/_-]?==|===)(?=\z|[^A-Za-z0-9+/_=-])" \
    "id:11931,phase:2,t:none,deny,status:403,log,msg:'Java4Shell known malformed Base64 token in XML value',tag:'CVE-2026-114938'"
```

경로 규칙은 **Base64url 값이 한 경로 세그먼트 전체를 차지하는 경우**를 검사합니다. 표준 Base64의 `/`, 애플리케이션 고유의 URL 재작성·재디코딩은 실제 라우팅에 맞춘 별도 정책이 필요합니다.

이 예제의 경로 처리는 **보안 수정이 적용된 libModSecurity v3, 최소 3.0.12 이후 구현**을 전제로 합니다. 이전 버전에는 경로 분리·디코딩 순서에 따른 별도 우회 문제가 있습니다. 운영에는 공급자가 보안 수정을 유지하는 버전을 사용해야 합니다.[^modsec-cve]

#### ④ 정규식 앞에 디코딩을 무조건 추가하지 않습니다

공통 검색식은 표준 Base64와 Base64url 문자 집합을 넓게 포함합니다. 전체 Base64 문법이나 JWT의 서명을 검증하는 식은 아니므로 정상 트래픽의 매칭 여부를 확인해야 합니다.

파싱된 쿼리·폼·JSON 값에는 `t:none`을 사용합니다. 이미 해석된 값에 URL 디코딩을 다시 일괄 적용하면 애플리케이션과 해석이 달라질 수 있습니다. `t:base64Decode`를 먼저 수행하면 검사하려는 원래 패딩 구조도 사라집니다.

현재 경로 변수 `REQUEST_FILENAME`도 percent-decoded 경로를 담으므로, 이 예제에서는 추가 URL 디코딩을 하지 않습니다.[^transaction]

---

### 🎯 실제 Base64 필드에는 정상 문법을 적용합니다

공통 패턴만으로는 잘못된 패딩 뒤에 추가 데이터가 붙는 경우 등 모든 문법 위반을 다루지 못합니다. 애플리케이션이 디코딩할 필드를 알면 해당 값 전체에 허용 문법을 적용할 수 있습니다.

예를 들어 `/api/decode`가 다음 세 형식을 지원하고, `payload`를 표준 Base64로 처리한다고 가정하겠습니다. 아래 값 `TQ==`는 정상적인 간단한 예시입니다.

| No. | 전송 방식 | 정상 요청 예 | 필드 검사 대상 |
| --- | --- | --- | --- |
| 1 | GET 쿼리 | `/api/decode?payload=TQ%3D%3D` | `ARGS:payload` |
| 2 | POST·PUT·PATCH 폼 | `payload=TQ%3D%3D` | `ARGS:payload` |
| 3 | POST·PUT·PATCH JSON | `{"payload":"TQ=="}` | `ARGS:json.payload` |

이 경우 다음 규칙을 추가합니다.

```apache
SecRule REQUEST_FILENAME "@streq /api/decode" \
    "id:11951,phase:2,t:none,deny,status:403,log,msg:'Invalid standard Base64 in designated payload field',tag:'CVE-2026-114938',chain"
    SecRule ARGS:payload|ARGS:json.payload "!@rx \A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}(?:==)?|[A-Za-z0-9+/]{3}=?)?\z" "t:none"
```

`chain`으로 경로를 먼저 확인하고, 해당 API의 `payload`가 허용 문법에 맞지 않으면 차단합니다. **GET·POST·PUT별로 같은 정규식을 복제할 필요가 없습니다.** 실제 API 경로와 필드명을 지정하면 됩니다.

이 문법은 정상 패딩과 패딩 생략을 허용하며, 빈 값도 허용합니다. 필수 값·빈 값 금지·중복 파라미터 처리는 API 계약에 따라 추가해야 합니다. JSON 중첩 필드의 실제 변수명, 같은 디코더로 연결되는 별칭과 rewrite 경로도 확인해야 합니다.

#### Base64url 필드는 문자 집합을 분리합니다

```apache
SecRule REQUEST_FILENAME "@streq /api/token" \
    "id:11952,phase:2,t:none,deny,status:403,log,msg:'Invalid Base64url in designated token field',tag:'CVE-2026-114938',chain"
    SecRule ARGS:token|ARGS:json.token "!@rx \A(?:[A-Za-z0-9_-]{4})*(?:[A-Za-z0-9_-]{2}(?:==)?|[A-Za-z0-9_-]{3}=?)?\z" "t:none"
```

표준 Base64와 Base64url은 허용 문자 집합이 다릅니다. Java의 MIME 디코더는 일부 비알파벳 문자를 무시하므로, MIME 입력에는 위의 일반 필드 규칙을 그대로 적용하지 않습니다.[^base64]

또한 전체 JWT는 하나의 Base64url 값이 아닙니다. `Bearer`라는 접두어만 보고 위 규칙을 모든 인증 토큰에 적용해서도 안 됩니다. 토큰 형식에 맞는 구성요소 검사와 서버의 인증·서명 검증은 별도로 유지해야 합니다.

---

### 🚧 검사 한도와 파싱 실패도 정책에 포함합니다

본문 일부만 검사한 뒤 나머지를 전달한다면 공격 값이 검사 밖에 놓일 수 있습니다. 파싱에 실패한 요청을 그대로 허용하는 구성에서도 애플리케이션과 WAF의 해석 차이가 생깁니다.

아래는 **1 MiB 본문, 인자 1000개를 사용하는 예제 설정**입니다. 정상 대용량 업로드를 제공하는 서비스는 실제 허용 범위에 맞춰 값을 조정해야 합니다.

```apache
SecRequestBodyLimit 1048576
SecRequestBodyNoFilesLimit 1048576
SecRequestBodyLimitAction Reject
SecArgumentsLimit 1000

SecRule INBOUND_DATA_ERROR "@eq 1" \
    "id:11920,phase:2,t:none,deny,status:413,log,msg:'Request body inspection limit exceeded'"

SecRule REQBODY_ERROR "@eq 1" \
    "id:11921,phase:2,t:none,deny,status:400,log,msg:'Request body parsing failed'"

SecRule &ARGS "@ge 1000" \
    "id:11923,phase:2,t:none,deny,status:400,log,msg:'Argument inspection limit reached'"
```

`SecArgumentsLimit`와 인자 수 거부 규칙의 숫자는 함께 바꿉니다. 위 설정은 보수적으로 1000개에 도달한 요청부터 거부합니다. 본문 검사 한도 초과는 엔진이 먼저 처리하면 403, 오류 규칙에서 처리하면 413이 될 수 있습니다. 중요한 결과는 **검사하지 못한 요청을 원본 서버로 보내지 않는 것**입니다.[^config][^transaction]

전체 예제에는 중복 Content-Type, URLENCODED 오류, multipart 엄격 검사 실패, 정규식 실행 오류·한도 초과를 거부하는 규칙도 포함했습니다. 이 오류 규칙은 관련 탐지 규칙과 함께 배치해야 합니다.

지정 API에는 허용 Content-Type도 정해야 합니다. JSON·폼만 받는 API라면 본문이 있는데 Content-Type이 없거나 미지원 형식인 경우 거부합니다. 압축 본문을 지원한다면 압축 해제와 검사 순서를 일치시켜야 하며, 지원하지 않는 API에서는 거부합니다. 파일의 두 예시 API는 JSON·폼만 허용하고 미지원 압축을 거부하도록 작성했습니다.

**본문 크기 제한은 Base64 문법 검사를 대신하지 않습니다.** 작은 입력도 취약 경로에 도달할 수 있으므로, 정상 서비스에 맞는 크기 제한과 입력 값 검사를 함께 적용해야 합니다.[^calif]

---

### ⏱️ 요청을 전달하기 전에 검사 결과를 확정해야 합니다

Java4Shell의 현재 요청을 차단하려면 WAF가 검사 결과를 확정한 뒤 원본 Java 서버로 요청을 전달해야 합니다. **요청을 먼저 전달하고 별도 프로세스나 AI가 나중에 분석하는 구성은 해당 요청의 디코더 도달을 사전에 막지 못합니다.**

| No. | 처리 방식 | 해당 요청에 대한 효과 |
| --- | --- | --- |
| 1 | 요청 검사 완료 후 동기 차단 | 공격 입력이 Java 서버에 도달하기 전에 거부 |
| 2 | 요청을 먼저 전달한 뒤 비동기 분석 | 후속 요청 차단·서버 조사·격리에 활용 |
| 3 | 응답 단계 차단 | 검사한 응답의 외부 전달 억제. 이미 발생한 서버 처리를 되돌리지는 못함 |
| 4 | 서버 행위 분석·EDR 연계 | Java 프로세스와 파일·계정·외부 연결의 이상 행위 확인 |

PLURA-WAF 운영에서도 **본문 임계 초과·URL 예외 정책이 실제로 어떤 전달 순서를 만드는지** 확인해야 합니다. 취약한 디코더로 이어지는 경로에는 요청 단계의 동기 차단이 적용되어야 합니다. 비동기 분석과 서버 행위 분석은 그 이후의 조사와 대응에 활용합니다.

NGINX에서는 보호 대상에 WAF를 연결합니다.

```nginx
modsecurity on;
modsecurity_rules_file /etc/nginx/modsecurity/main.conf;
proxy_request_buffering on;
```

ModSecurity의 `main.conf`에는 공통 규칙 파일을 포함합니다.

```apache
Include /etc/nginx/modsecurity/java4shell.conf
```

`SecRule`은 NGINX 설정 본문이 아니라 연결된 ModSecurity 파일에 넣습니다. **요청 버퍼링만 켜는 것으로 차단이 완성되지는 않습니다.** `SecRuleEngine On`과 phase 2의 실제 차단이 함께 동작해야 합니다.[^connector][^nginx-buffering]

기존 CRS와 설정을 유지하며 통합하고 규칙 ID 충돌을 확인합니다. 특히 phase 1의 `allow`나 `allow:request`는 뒤의 본문 검사 전체를 생략시킬 수 있습니다. Include 순서만으로 해결되지 않으므로 전체 허용·skip·`ctl:ruleEngine=Off`·`ctl:requestBodyAccess=Off` 예외를 함께 점검해야 합니다.[^actions]

---

### 🧪 규칙 등록 이후에는 무엇을 검증해야 할까요?

**정규식의 일치 결과와 실제 HTTP 요청의 차단 결과는 구분해 확인해야 합니다.**

제공한 설정의 **7개 규칙에서 정규식을 추출해 오프라인 PCRE2로 검사한 결과, 2,464개 사례의 일치·불일치 결과가 설정한 기대값과 일치**했습니다. 정상 Base64, 공개된 비정상 꼬리, 경로 세그먼트, 지정 필드의 허용 문법과 **탐지 범위를 확인하기 위한 알려진 비검출 사례**를 포함합니다.

| No. | 검증 범위 | 결과·확인 사항 |
| --- | --- | --- |
| 1 | 정규식 매칭 | 7개 규칙, 2,464개 매칭 사례의 기대값 일치 |
| 2 | ModSecurity 설정 로드·chain 실행 | 해당 검사 수치에 포함되지 않음. 실제 배포 환경에서 확인 |
| 3 | GET·POST·PUT·PATCH의 파서 동작 | 무해한 테스트 문자열이 올바른 변수와 규칙 ID에 도달하는지 확인 |
| 4 | 실제 요청 거부 | WAF의 응답과 원본 서버 미도달을 함께 확인 |
| 5 | 서비스 영향 | 정상 로그인·API·업로드가 의도대로 동작하는지 확인 |

이 결과는 실제 JVM 취약점 재현이나 모든 변형 공격 차단을 검증한 수치가 아닙니다. 정규식 결과 파일에는 알려진 비검출 범위도 별도로 기록했습니다.

#### 공격 입력 없이 JSON 파서를 확인하는 방법

별도 테스트 WAF에서 다음 임시 규칙을 사용하면 무해한 문자열로 JSON 파싱과 해당 규칙의 동작을 확인할 수 있습니다. 이 규칙은 검증 후 제거합니다.

```apache
SecRule ARGS:json.payload "@streq PLURA_WAF_PARSER_TEST" \
    "id:11985,phase:2,t:none,deny,status:403,log,msg:'Parser smoke: JSON payload'"
```

다음 주소는 **별도로 구성한 로컬 테스트 WAF** 예시입니다. 실제 테스트 주소를 사용하고, `/__waf_parser_test`는 테스트용 upstream으로 연결합니다.

```bash
WAF_TEST_ORIGIN='http://127.0.0.1:18080'

curl --noproxy '*' -i -X PUT \
  -H 'Content-Type: application/json' \
  --data '{"payload":"PLURA_WAF_PARSER_TEST"}' \
  "$WAF_TEST_ORIGIN/__waf_parser_test"

curl --noproxy '*' -i -X PATCH \
  -H 'Content-Type: application/merge-patch+json' \
  --data '{"payload":"PLURA_WAF_PARSER_TE\u0053T"}' \
  "$WAF_TEST_ORIGIN/__waf_parser_test"
```

두 요청은 JSON 파싱 후 같은 값을 가집니다. **403 응답, 규칙 ID `11985`, 원본 서버 미도달**이 함께 확인되어야 합니다. 다른 규칙이 먼저 거부한 403을 JSON 파서 성공으로 판단하면 안 됩니다. 정상 문자열 요청은 테스트용 upstream에 도달하는지도 비교합니다.

같은 방식으로 GET 쿼리, POST·PUT 폼, 쿠키, 헤더, XML을 확인합니다. `nginx -t`의 성공은 설정 문법 확인이며 파서와 차단 동작의 확인까지 대신하지는 않습니다.

---

### ✅ WAF 보호와 Java 업데이트를 함께 완료합니다

이 규칙이 검사하는 범위는 WAF가 실제로 해석할 수 있는 HTTP 입력입니다. MIME·중첩 인코딩·업로드 파일 내부·압축 본문·WebSocket 업그레이드 이후 메시지에는 별도 처리가 필요합니다. Java가 외부 서버에서 받는 데이터와 내부 메시지 등 인바운드 WAF를 거치지 않는 경로도 있습니다.[^cloudflare]

따라서 운영에서는 다음 작업을 병행합니다.

| No. | 담당 영역 | 완료 기준 |
| --- | --- | --- |
| 1 | WAF | 보호 API와 입력 위치를 지정하고 원본 서버 전달 전 차단 확인 |
| 2 | 애플리케이션 | Base64 필드·디코더 종류·허용 형식과 중첩 처리 경로 확인 |
| 3 | Java 런타임 | 수정 버전 적용 또는 검증된 JVM 임시 완화 후 재시작·실제 반영 확인 |
| 4 | 운영·관제 | 정상 서비스 영향과 Java 프로세스의 이상 행위 확인 |

즉시 패치하기 어려운 환경은 공급자가 안내한 JVM 임시 완화를 검토하고, 실제 서비스가 사용하는 런타임에 적용됐는지 확인합니다. 내장 JDK/JRE와 컨테이너도 수정 대상에서 빠지지 않아야 합니다.[^microsoft]

### 📌 대응 원칙

**Java4Shell WAF 대응은 검사할 위치, 허용할 문법, 차단할 시점을 구체적으로 정하는 작업입니다.** GET·POST·PUT·PATCH의 입력을 적절히 파싱하고, 알려진 비정상 패딩과 지정 필드의 문법 위반을 Java에 전달하기 전에 거부해야 합니다.

> **WAF는 검사 가능한 공격 입력의 도달을 막습니다.**
> **Java 패치는 취약한 실행 경로를 수정합니다.**
> 두 조치를 병행하고 실제 동작으로 완료 여부를 확인해야 합니다.

---

### 📦 규칙과 검증 자료

실습 자료 `java4shell-waf-rules.zip`에는 다음 파일이 포함되어 있습니다. 이 글의 코드는 전체 설정의 주요 발췌이며, 실제 적용에는 전체 설정을 통합해야 합니다.

| No. | 파일 | 내용 |
| --- | --- | --- |
| 1 | `java4shell.conf` | 파서 선택, 공통 탐지, 검사 한도·오류 거부 |
| 2 | `field-policy.conf.example` | API 경로와 Base64 필드 문법 검증 |
| 3 | `nginx-integration.conf.example` | NGINX 연결 설정 |
| 4 | `tests/parser-smoke.conf.example` | 무해한 파서 확인 규칙 |
| 5 | `tests/verify_patterns.py` | 오프라인 PCRE2 검증기 |
| 6 | `tests/regex-results.json` | 검사 결과와 미검증 범위 |
| 7 | `README.md`, `SHA256SUMS` | 적용 설명과 파일 무결성 확인 |

---

## 📚 PLURA-Blog

- [웹방화벽(WAF) 선택 체크리스트](https://blog.plura.io/ko/tech/checklist-waf/)
- [일반 WAF 환경에서 PLURA-WebProxy로 Web Body 정보를 관리하는 방법](https://blog.plura.io/ko/tech/plura-webproxy-architecture/)

---

## 📚 참고 자료

[^calif]: [Calif — Java4Shell](https://calif.io/java4shell/). 취약점 원인, 마지막 단위와 비정상 패딩 처리, JVM 완화.
[^microsoft]: [Microsoft — Addressing Java4Shell CVE-2026-114938: upgrade guidance and Azure WAF mitigations](https://techcommunity.microsoft.com/blog/azurenetworksecurityblog/addressing-java4shell-cve-2026-114938-upgrade-guidance-and-azure-waf-mitigations/4574305). HTTP 입력 위치별 WAF 규칙과 런타임 업데이트.
[^phases]: [ModSecurity — Processing Phases](https://modsecurity.org/docs/3-reference-manual/3-1-processing-phases/).
[^variables]: [ModSecurity — Variables](https://modsecurity.org/docs/3-reference-manual/3-3-variables/index.html).
[^transaction]: [ModSecurity — transaction.cc](https://github.com/owasp-modsecurity/ModSecurity/blob/v3/master/src/transaction.cc). URI, ARGS와 본문 처리 구현.
[^decoder]: [Oracle Java SE 17 — Base64.Decoder](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/Base64.Decoder.html). 패딩 생략과 정상 패딩 요구.
[^base64]: [Oracle Java SE 17 — Base64](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/Base64.html). Basic·URL-safe·MIME 구분.
[^config]: [ModSecurity — Configuration Directives](https://modsecurity.org/docs/3-reference-manual/3-2-configuration-directives/). 본문·인자 한도와 검사 설정.
[^actions]: [ModSecurity — Actions](https://modsecurity.org/docs/3-reference-manual/3-5-actions/). allow·chain·ctl 동작.
[^modsec-cve]: [OWASP ModSecurity — CVE-2024-1019](https://github.com/OWASP/www-project-modsecurity/blob/main/tab_cves.md). 경로 해석에 관한 이전 버전의 우회 문제와 수정 범위.
[^connector]: [ModSecurity-nginx 공식 connector](https://github.com/owasp-modsecurity/ModSecurity-nginx).
[^nginx-buffering]: [NGINX — proxy_request_buffering](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_request_buffering).
[^cloudflare]: [Cloudflare — How Cloudflare WAF helps protect against Java4Shell](https://blog.cloudflare.com/java4shell-waf-protection/). WAF 보호 범위와 인바운드 HTTP 밖의 경로.
