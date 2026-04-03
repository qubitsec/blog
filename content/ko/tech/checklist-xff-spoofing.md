---
title: "공격자는 왜 X-Forwarded-For를 조작하는가 — 웹방화벽이 놓치기 쉬운 실제 IP 우회 문제"
date: 2026-04-04
draft: false
featured_image: "cdn/tech/checklist-xff-spoofing.png"
description: "공격자가 X-Forwarded-For(XFF)를 조작해 자신의 실제 IP를 숨기는 이유와 위험성, PLURA의 HAProxy 기반 대응 방식, 그리고 다른 SaaS WAF 제품에서 반드시 확인해야 할 체크리스트를 정리한다."
tags: ["XFF", "X-Forwarded-For", "WAF", "HAProxy", "SaaS WAF", "IP 우회", "웹보안", "PLURA", "체크리스트", "Checklist"]
---

## 공격자는 왜 X-Forwarded-For를 조작할까

웹 서비스 앞단에 프록시, CDN, 로드밸런서, WAF가 놓이면  
원 서버는 TCP 연결의 실제 원발신자가 아니라  
바로 앞 장비의 주소를 먼저 보게 됩니다.

그래서 업계는 보통  
`X-Forwarded-For(XFF)` 같은 헤더에  
“원래 요청자의 IP”를 담아 뒤쪽 시스템에 전달합니다.

문제는 여기서 시작됩니다.

`X-Forwarded-For`는  
본질적으로 **HTTP 헤더**입니다.  
즉, 클라이언트도 보낼 수 있고, 공격자도 조작할 수 있습니다.

공격자가 직접 XFF를 넣어 보내면  
뒤쪽 시스템이 그 값을 그대로 신뢰하는 순간,  
공격자의 실제 IP는 희미해지고  
로그에는 엉뚱한 주소가 남게 됩니다.

이것은 단순한 로그 품질 문제가 아닙니다.

- IP 기반 차단이 무력화될 수 있습니다.
- 크리덴셜 스터핑 탐지가 흔들릴 수 있습니다.
- 동일 공격자의 반복 시도를 서로 다른 사용자처럼 오인할 수 있습니다.
- 포렌식 시 실제 공격 경로를 잘못 해석할 수 있습니다.
- “차단은 했는데 누구를 차단했는지”가 모호해질 수 있습니다.

실제로 주요 클라우드/보안 벤더 문서들도  
XFF는 중간 프록시를 거치며 변경될 수 있고,  
공격자가 우회를 위해 값을 조작할 수 있다고 명시합니다.  
AWS WAF는 forwarded IP 헤더는 공격자가 조작할 수 있다고 경고하고,  
Google Cloud Load Balancer는 기존 XFF 값 앞부분을 검증하지 않는다고 설명합니다.  
Azure Front Door 역시 기존 XFF가 있으면 자신의 관측 IP를 뒤에 덧붙이는 방식입니다. :contentReference[oaicite:0]{index=0}

즉, 핵심은 단순합니다.

> **XFF를 “받는 것”과, XFF를 “신뢰할 수 있게 만드는 것”은 전혀 다른 문제입니다.**

이 지점을 놓치면  
공격자는 매우 손쉽게 자신의 출발지를 흐릴 수 있습니다.

---

## 왜 위험한가 — 실제 운영 관점에서 보는 XFF 우회

보안 운영에서 IP는 여전히 매우 중요한 축입니다.

물론 오늘날 공격은  
IP 하나만으로 판단하지 않습니다.  
계정, 세션, User-Agent, 요청 본문, 응답 패턴, 시간대, 국가, ASN, 실패율 등을 함께 봐야 합니다.

그럼에도 불구하고  
IP는 여전히 다음과 같은 판단의 출발점입니다.

- 동일 출발지의 반복 로그인 시도
- 특정 대역의 공격 집중 여부
- 국가/지역 기반 우회 흔적
- CDN/프록시 뒤 실제 사용자 식별
- 사고 발생 후 연관 행위 추적

그런데 XFF가 조작되면  
이 모든 분석이 흔들릴 수 있습니다.

예를 들어, 공격자가 로그인 공격을 하면서  
매 요청마다 임의의 XFF 값을 넣으면  
뒤쪽 시스템은 이를 서로 다른 사용자 IP로 오인할 수 있습니다.  
그러면 분산 공격처럼 보이거나,  
반대로 정상 프록시 체인을 공격으로 오판할 수도 있습니다.

더 위험한 것은  
사후 분석입니다.

사고가 발생한 뒤  
“공격자는 어느 IP였는가”를 확인해야 하는데,  
원 로그가 이미 오염되어 있으면  
분석 자체가 왜곡됩니다.  
보안은 결국 기록에서 출발하는데,  
XFF 신뢰 경계가 무너지면  
그 기록의 출발점이 무너집니다.

---

## PLURA는 이 문제를 어떻게 다루는가

PLURA는 기본 L4/L7 프록시로 HAProxy를 사용하며,  
XFF를 무조건 그대로 믿는 방식이 아니라  
**직접 관측한 소스 IP를 기준으로 다시 헤더를 구성하는 방식**을 사용합니다.

사용 중인 설정은 다음과 같습니다.

```haproxy
#---------------------------------------------------------------------
# for security : http-request add-header X-Forwarded-For %[src]
#---------------------------------------------------------------------
http-request set-header X-Forwarded-For %[src],%[req.hdr(X-Forwarded-For)] if { req.hdr(X-Forwarded-For) -m found }
```

이 설정의 핵심은 `%[src]` 입니다.

`%[src]`는
HAProxy가 **실제 TCP 연결에서 직접 본 접속 IP**입니다.  
즉, 클라이언트가 헤더 안에 뭐라고 써서 보내든  
PLURA 앞단의 HAProxy는  
자신이 실제로 본 접속 주소를 먼저 확보할 수 있습니다.

이렇게 되면 의미가 달라집니다.

기존에 공격자가
`X-Forwarded-For: 1.2.3.4` 같은 값을 넣어 보내더라도,  
HAProxy는 그 앞에 자신이 직접 본 `src`를 붙입니다.

결과적으로 뒤쪽 시스템은  
최소한 **바로 직전 프록시가 직접 관측한 주소**를  
체인 안에서 분리해 볼 수 있게 됩니다.

이 방식의 장점은 분명합니다.

첫째,  
공격자가 임의의 XFF를 넣어도  
프록시가 관측한 실제 접속 주소를 완전히 숨기기 어렵습니다.

둘째,  
원 서버나 분석 시스템에서  
“맨 앞의 값”, “신뢰 가능한 마지막 프록시 직전 값”,  
“전체 체인”을 정책적으로 해석할 수 있습니다.

셋째,  
포렌식 시에도  
“공격자가 넣은 값”과  
“프록시가 직접 본 값”을 구분할 단서를 남길 수 있습니다.

물론 이것만으로 모든 문제가 끝나는 것은 아닙니다.

진짜 중요한 것은
**어느 프록시까지를 신뢰할 것인지**,
**어느 위치의 IP를 실제 클라이언트로 해석할 것인지**,
**백엔드가 임의 헤더를 직접 신뢰하지 않도록 설계되었는지** 입니다.

즉, HAProxy 설정은 매우 중요하지만  
그보다 더 중요한 것은  
전체 서비스 체인에서의 **신뢰 경계 정의**입니다.

---

## 운영자가 꼭 이해해야 할 포인트

XFF 문제는 사실 “헤더 설정” 문제가 아니라  
“신뢰 모델” 문제입니다.

다음 중 하나라도 불분명하면  
XFF 우회는 언제든 다시 생깁니다.

### 1. 원 서버가 누구의 헤더를 신뢰하는가

원 서버가  
“인터넷에서 직접 들어온 요청의 XFF”와  
“신뢰된 프록시가 재구성한 XFF”를  
구분하지 못하면 안 됩니다.

### 2. 프록시 체인에서 어느 홉을 실제 사용자로 볼 것인가

CDN → WAF → LB → Reverse Proxy → Origin  
구조라면,  
클라이언트 IP 해석 기준이 명확해야 합니다.

### 3. 로그에 원본과 정규화 값을 모두 남기는가

운영과 포렌식 관점에서는  
가능하면 다음이 함께 남는 편이 좋습니다.

* 실제 연결 소스 IP
* 정규화한 Client IP
* 원본 XFF
* 최종 해석된 사용자 IP

### 4. IP 기반 탐지가 헤더 조작에 취약하지 않은가

크리덴셜 스터핑, Rate Limit, Bot 탐지, Geo/IP 차단이  
헤더 한 줄에 지나치게 의존하면  
공격자는 쉽게 우회 방향을 찾습니다.

---

## 다른 SaaS WAF에서는 무엇을 확인해야 할까

여기서부터가 중요합니다.

많은 SaaS WAF는  
XFF 관련 기능을 가지고 있습니다.  
하지만 이름이 다릅니다.

어떤 제품은 `True-Client-IP` 라고 부르고,  
어떤 제품은 `Forwarded IP configuration`,  
어떤 제품은 `Trusted Client IP Headers`,  
어떤 제품은 단순히 `restore original visitor IP`라고 부릅니다.

그래서 벤더에게는  
“XFF spoofing 방지 기능 있습니까?”라고만 묻기보다,  
아래 체크리스트로 구체적으로 확인해야 합니다.

---

## SaaS WAF 점검 체크리스트 — XFF 우회 방지 중심

### 1️⃣ 원발신자 IP를 위한 **전용 신뢰 헤더**가 있는가

가장 좋은 구조는  
원 헤더를 그대로 믿는 것이 아니라  
WAF/CDN/프록시가 직접 관측한 값을  
별도 신뢰 헤더로 전달하는 것입니다.

예를 들어 Cloudflare는  
원 서버에서 `X-Forwarded-For` 대신  
`CF-Connecting-IP` 또는 `True-Client-IP` 사용을 권장합니다.  
이는 단일 IP 형식으로 전달되어  
원본 XFF보다 해석이 단순하고 안전합니다. ([Cloudflare Docs][1])

**확인 질문**

* 귀사 제품은 XFF 외에 신뢰 가능한 단일 client IP 헤더를 제공하는가?
* 그 헤더는 인터넷 클라이언트가 직접 넣을 수 없는가?
* 백엔드에서 그 헤더만 신뢰하도록 가이드하는가?

---

### 2️⃣ 기존 XFF를 **덮어쓸 수 있는가**, 아니면 단순 append만 하는가

이 항목은 매우 중요합니다.

Google Cloud Load Balancer는  
기존 XFF가 있으면 그 뒤에  
`<client-ip>,<load-balancer-ip>`를 덧붙이지만,  
앞부분의 값은 검증하지 않는다고 명시합니다.  
대신 backend custom request header로  
기존 XFF를 재구성해 덮어쓰는 방법을 안내합니다.  
Azure Front Door도 기존 XFF가 있으면  
자신이 본 client socket IP를 뒤에 추가하는 방식입니다. ([Google Cloud Documentation][2])

**확인 질문**

* 기존 XFF를 그대로 보존하는가?
* 필요하면 기존 XFF를 제거/재작성할 수 있는가?
* append만 가능한지, overwrite 정책도 가능한지?

---

### 3️⃣ “신뢰할 프록시” 또는 “trusted client headers” 개념이 있는가

F5 Distributed Cloud는  
`Trusted Client IP Headers` 설정을 제공하며,  
신뢰할 헤더를 순서대로 정의할 수 있다고 문서화하고 있습니다.  
이런 기능은 다단 프록시 환경에서 매우 중요합니다. ([F5 Distributed Cloud Docs][3])

**확인 질문**

* trusted proxy / trusted client header 기능이 있는가?
* 어떤 홉까지 신뢰할지 설정 가능한가?
* 다단 프록시 환경에서 해석 우선순위를 지정할 수 있는가?

---

### 4️⃣ WAF의 IP 기반 룰이 **어느 값을 기준으로 동작하는가**

AWS WAF는 기본적으로 request origin IP를 사용하지만,  
룰별로 `X-Forwarded-For` 같은 헤더를 쓰도록 설정할 수 있습니다.  
동시에 AWS는 공격자가 이 헤더를 조작할 수 있다고 경고하며,  
malformed/invalid/missing IP에 대한 fallback 동작도 설정하라고 안내합니다. ([AWS 문서][4])

**확인 질문**

* IP 차단, Geo 차단, Rate Limit은 source IP 기준인가, forwarded IP 기준인가?
* forwarded IP 사용 시 invalid header fallback을 어떻게 처리하는가?
* 헤더가 없거나 비정상이면 차단인가, 무시인가?

---

### 5️⃣ 백엔드 로그와 WAF 로그에서 **동일한 client IP 기준**을 유지하는가

WAF는 한 값을 client IP로 보고,  
원 서버는 다른 값을 client IP로 보면  
운영과 포렌식이 어긋납니다.

Imperva는 reverse proxy 환경에서  
forwarded client IP를 웹 서버로 전달하는 설정을 제공하고,  
Akamai도 true client IP 전달 및 connecting IP와 XFF 중 어떤 값을 고려할지 선택하는 기능을 제공합니다. ([Imperva Documentation][5])

**확인 질문**

* WAF 로그의 client IP와 origin 로그의 client IP를 일치시킬 수 있는가?
* 원 서버용 header 전달 정책이 있는가?
* 제품 문서에 권장 origin logging 방식이 제시되어 있는가?

---

### 6️⃣ “XFF를 쓸 수 있다”가 아니라 “XFF spoofing에 안전한 운영 가이드”가 있는가

이 항목이 실제로는 가장 중요합니다.

기능이 있어도  
운영 가이드가 없으면  
현장에서는 결국 잘못 설정됩니다.

좋은 벤더 문서는 보통 다음을 함께 설명합니다.

* 어떤 헤더를 신뢰해야 하는가
* 어떤 헤더는 신뢰하면 안 되는가
* 다중 프록시 체인에서 어느 위치를 써야 하는가
* overwrite/append 차이는 무엇인가
* malformed header 처리 정책은 무엇인가

AWS, Google, Cloudflare 문서는  
각각 다른 형태지만  
이 문제를 “그냥 XFF 쓰세요” 수준으로 끝내지 않고  
위험과 해석상의 주의점을 적어두고 있습니다. ([AWS 문서][6])

**확인 질문**

* 공식 문서에 spoofing/alteration/trust boundary 주의사항이 있는가?
* 운영자용 베스트 프랙티스가 있는가?
* 기술지원 없이도 올바르게 설정할 수 있게 문서화되어 있는가?

---

## 벤더 확인용 요약표

> 아래 표는 “제품 비교표”라기보다,  
> **벤더에게 반드시 물어봐야 할 확인 포인트**를 빠르게 정리한 것입니다.  
> 일부 기능은 요금제, 배포 구조, 연계 제품에 따라 달라질 수 있으므로  
> 도입 전 실제 구성 기준으로 재확인이 필요합니다.

| 제품/계열                         | 문서상 확인된 포인트                                                                                                                  | 운영상 해석                                            |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| **Cloudflare**                | `CF-Connecting-IP` 제공, Enterprise는 `True-Client-IP` 사용 가능. 원 서버에서 XFF보다 전용 헤더 사용 권장. ([Cloudflare Docs][1])                  | **우수**. “원본 XFF 신뢰” 대신 별도 신뢰 헤더 중심 설계 가능          |
| **AWS WAF**                   | Forwarded IP 사용 가능. 다만 AWS가 공격자에 의한 header alteration 가능성을 명시적으로 경고. malformed IP fallback 필요. ([AWS 문서][6])                 | **주의 필요**. 기능은 있으나, 잘못 쓰면 우회 여지 존재                |
| **Google Cloud Armor / LB**   | LB가 XFF 뒤에 client IP, LB IP를 append. 기존 앞부분은 검증하지 않음. custom request header로 overwrite 가능. ([Google Cloud Documentation][2]) | **주의 필요**. append만 믿으면 위험, overwrite 설계 여부 확인 필요  |
| **Azure Front Door WAF**      | 기존 XFF가 있으면 client socket IP를 뒤에 append. XFF 보존. ([Microsoft Learn][7])                                                      | **주의 필요**. backend에서 raw XFF를 그대로 신뢰하면 안 됨        |
| **F5 Distributed Cloud WAAP** | Trusted Client IP Headers 설정 제공. 헤더 우선순위 지정 가능. ([F5 Distributed Cloud Docs][3])                                             | **좋음**. 다단 프록시/신뢰 헤더 설계에 유리                       |
| **Imperva Cloud WAF**         | reverse proxy 환경에서 forwarded client IP를 header로 전달하는 기능 문서화. ([Imperva Documentation][5])                                    | **확인 필요**. trusted proxy 해석 정책과 원 서버 연동 방식 재확인 필요 |
| **Akamai**                    | true client IP 전달 옵션, connecting IP vs XFF 고려 옵션 제공. 일부 변수는 request header override 무시 버전도 존재. ([Akamai TechDocs][8])        | **좋음**. 단, 어떤 변수/헤더를 실제 룰과 로그에서 쓰는지 명확히 해야 함      |

---

## 벤더 미팅에서 바로 써도 되는 질문 10개

### 질문 1

귀사 제품은 원발신자 IP를  
`X-Forwarded-For` 외에 별도 신뢰 헤더로 전달합니까?

### 질문 2

기존에 클라이언트가 넣은 XFF를  
보존합니까, 덮어씁니까, 아니면 재구성합니까?

### 질문 3

append만 합니까, overwrite도 가능합니까?

### 질문 4

trusted proxy / trusted client header / trusted hop 설정이 있습니까?

### 질문 5

IP 기반 차단, rate limit, geo rule은  
어느 값을 기준으로 동작합니까?

### 질문 6

header가 비정상, 누락, 변조된 경우  
차단/무시/우회 중 어떻게 처리합니까?

### 질문 7

원 서버 로그와 WAF 로그에서  
동일한 client IP 기준을 유지할 수 있습니까?

### 질문 8

공식 문서에 XFF spoofing 또는 forwarded header trust boundary에 대한 가이드가 있습니까?

### 질문 9

다단 프록시(CDN → WAF → LB → Reverse Proxy) 환경에서  
권장 해석 순서를 제공합니까?

### 질문 10

사고 발생 시 원본 header, 정규화된 client IP, 실제 연결 소스 IP를  
모두 확인할 수 있습니까?

---

## 정리

XFF 문제는 사소한 헤더 설정 이슈가 아닙니다.

이것은
**공격자를 누구로 기록할 것인가**,  
**누구를 차단할 것인가**,  
**무엇을 증거로 남길 것인가**의 문제입니다.

공격자는 늘 가장 값싸고 쉬운 우회부터 시도합니다.  
그리고 XFF 조작은  
그중에서도 매우 현실적이고 흔한 방법입니다.

그래서 중요한 것은  
“XFF를 쓴다”가 아닙니다.

> **신뢰할 수 없는 XFF를 어떻게 통제하고,  
> 신뢰 가능한 client IP를 어떻게 다시 정의할 것인가.**

PLURA는 HAProxy를 통해  
직접 관측한 소스 IP를 기준으로  
XFF를 재구성하는 방향으로  
이 우회 위험을 줄이고 있습니다.

그리고 다른 SaaS WAF를 검토할 때도  
단순히 “원 IP 보입니다”라는 설명으로는 부족합니다.

반드시 확인해야 할 것은 이것입니다.

> **그 IP가 정말 신뢰 가능한가?**  
> **공격자가 헤더 한 줄로 흔들 수 없는가?**

보안은 결국 기록입니다.  
그리고 IP 기록의 신뢰성이 무너지면  
그 뒤의 분석과 대응도 함께 흔들립니다.

---

## 참고

이 글의 구성과 체크리스트 전개 방식은 사용자가 제공한 WAF 체크리스트 문서의 톤과 구조를 참고했습니다. 

---

[1]: https://developers.cloudflare.com/fundamentals/reference/http-headers/?utm_source=chatgpt.com "Cloudflare HTTP headers"
[2]: https://docs.cloud.google.com/load-balancing/docs/https?utm_source=chatgpt.com "External Application Load Balancer overview"
[3]: https://docs.cloud.f5.com/docs-v2/multi-cloud-app-connect/how-to/load-balance/create-http-load-balancer?utm_source=chatgpt.com "Create HTTP Load Balancer"
[4]: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-ipset-match.html?utm_source=chatgpt.com "IP set match rule statement"
[5]: https://docs.imperva.com/bundle/v14.7-waf-api-reference-guide/page/61859.htm?utm_source=chatgpt.com "Report Forwarded Client IP in Reverse Proxy"
[6]: https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-forwarded-ip-address.html?utm_source=chatgpt.com "Using forwarded IP addresses in AWS WAF"
[7]: https://learn.microsoft.com/en-us/azure/frontdoor/front-door-http-headers-protocol?utm_source=chatgpt.com "Protocol support for HTTP headers in Azure Front Door"
[8]: https://techdocs.akamai.com/property-mgr/docs/client-ip?utm_source=chatgpt.com "Client IP"
