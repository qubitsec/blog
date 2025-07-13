---
title: "웹방화벽 우회 공격에 대응하기"
date: 2025-07-10T15:30:00
draft: false
description: "웹방화벽은 웹 서비스를 보호하는 가장 강력한 방어선입니다. 그런데도 웹 공격에 대응하는 일은 왜 이토록 어려울까요? 그 원인과 해결 방안을 제시합니다."
featured_image: "cdn/column/waf_dev_exception.png"
tags: ["웹방화벽", "우회 공격", "보안 예외", "웹 개발", "보안 설계", "시큐어 코딩"]
---

🛡️ **웹방화벽, 완벽할까요?**  
웹방화벽(WAF)은 웹 서비스 보안을 위한 핵심 수단입니다. 그러나 **반복되는 예외 처리**와 **우회 공격**은 운영자와 개발자 모두에게 고민을 안겨줍니다.

<!--more-->

![웹방화벽 예외처리와 보안 허점](https://blog.plura.io/cdn/column/waf_dev_exception.png)

---

### 1. **정상 요청인데 왜 차단될까?**

웹방화벽은 SQL 인젝션, 크로스사이트 스크립팅(XSS) 등 다양한 웹 공격을 탐지합니다.  
하지만 다음과 같은 요청은 WAF 룰셋에 의해 **공격으로 오인**될 수 있습니다:

- `GET` 요청에 IP, 토큰, 민감한 값 포함  
- `POST` 본문에 SQL 또는 `<script>` 포함  
- 테스트용 URI, 백도어 경로 등이 제거되지 않은 상태  

결국 **의도하지 않은 요청 구조**가 보안 정책과 충돌하고,  
운영 중 **반복적인 화이트리스트 등록** 요청이 발생합니다.

---

### 2. **예외 처리는 우회 공격의 시작점이 될 수 있습니다**

특정 URL이나 경로를 예외 처리하면 해당 요청은 검사 대상에서 제외됩니다.  
이로 인해 다음과 같은 리스크가 발생합니다:

- 공격자가 URL 패턴을 통해 우회 경로 탐색  
- 우회된 경로를 통한 악성 요청 유입  
- 보안 점검 시 가장 먼저 공격 시도되는 대상이 됨  

> ✅ **예외는 임시 수단입니다.**  
> 예외 등록 시에는 **오탐률 기준 승인** + **자동 만료**(Time-bound)를 반드시 병행해야 합니다.

---

### 3. **개발 단계에서 이미 우회 경로가 만들어진다**

| 개발 방식 예시                        | 우회 공격 가능성                        |
|-------------------------------------|--------------------------------------|
| IP·토큰을 `GET`으로 전달             | URL 로그 노출 → 인증 우회 가능성      |
| JSON 외 포맷 사용 (`form`, `text`)   | Content-Type 혼동 → 파서 오탐 유발     |
| 테스트 경로 미삭제 상태로 운영       | 백도어 또는 인증 우회 가능성          |
| 예외 등록 후 장기 방치               | 실제 공격자가 해당 경로만 집중 시도    |

> 대부분은 **WAF 고려 없는 개발 설계**에서 비롯됩니다.

---

### 4. **해결책: 개발과 보안을 동시에 고려하라**

현실적인 대응 방안은 다음과 같습니다:

- ✅ **초기 개발부터 WAF 차단 모드로 테스트**  
- ✅ **API 요청 구조를 보안 정책 내에서 설계**  
- ✅ **CI/CD에 WAF 테스트 자동화 포함 (DAST)**  

| 전통적 접근                             | 보안 중심 접근 (Secure-by-Design)           |
|----------------------------------------|--------------------------------------------|
| 개발 → 배포 → WAF 설정 → 예외 처리 반복     | WAF 차단 모드로 먼저 설정 → 정책 기반 설계 |

이런 방식은 **우회 공격 경로 자체를 사전에 제거**하며  
운영 중 불필요한 예외 요청 없이 **안정적인 보안 운영**을 가능하게 합니다.

---

### ✅ 결론: 웹방화벽은 개발 초기부터 함께 가야 한다

웹방화벽은 **사후 대응 도구가 아닙니다.**  
**개발 초기부터 함께 설계되어야 할 보안 파트너**입니다.

우회 공격의 핵심은 **예외 처리된 경로**이며,  
이 문제는 **설계 단계에서의 인식 변화**로 충분히 줄일 수 있습니다.

---

### 📚 함께 보면 좋은 글 PLURA-Blog

- [웹방화벽 없는 홈페이지 운영은 안전벨트 없는 운전과 같습니다](https://blog.plura.io/ko/column/web-application-firewall-is-like-a-seatbelt/)
- [웹 서비스의 취약점은 대응할 수 있을까?](https://blog.plura.io/ko/column/vulnerabilities_web/)
- [워드프레스로 만든 사이트 필수 보안 TOP 10](https://blog.plura.io/ko/column/wordpress_security_top10/)
- [웹방화벽(WAF)에 대한 이해](https://blog.plura.io/ko/column/onpremise_inline_waf/)
- [웹을 통한 데이터유출 해킹 대응 개론](https://blog.plura.io/ko/column/dlp/)
- [WEB 관리자 페이지 노출 대응](https://blog.plura.io/ko/respond/admin_page_exposure_mitigation/)
- [SQL 인젝션](https://blog.plura.io/ko/respond/sql_injection/)
- [크리덴셜 스터핑](https://blog.plura.io/ko/respond/credential_stuffing/)
- [크리덴셜 스터핑 공격 대응하기](https://blog.plura.io/ko/respond/credential-stuffing-countermeasures/)
- [웹 서비스 공격에 대응하기 against 샤오치잉(Xiaoqiying)](https://blog.plura.io/ko/respond/web-service-attack-response-against-xiaoqiying/)
