---
title: "IPS와 NDR 차이와 한계"
date: 2023-02-23
draft: false
description: "IPS와 NDR의 주요 차이점과 한계를 분석하고, '이미 WAF가 있다면 왜 또 필요한지'라는 관점에서 호스트 기반 보안 시스템의 대안적 필요성을 논의합니다."
featured_image: "cdn/column/ips_vs_ndr.jpg"
tags: ["IPS", "NDR", "보안", "네트워크 보안", "암호화 패킷", "Endpoint Security"]
---

🔍 **IPS**(Intrusion Prevention System)와 **NDR**(Network Detection and Response)은 모두 **네트워크 보안** 범주에 속합니다. 그러나 현대의 보안 환경, 특히 **TLS/SSL 등 암호화가 보편화된 환경**에서는 이들 솔루션이 **제 기능을 제대로 발휘하기 어렵고**, 이미 **WAF**(Web Application Firewall)를 도입했다면 “굳이 IPS·NDR을 추가로 운영해야 하나?”라는 의문이 생기게 됩니다.

이 문서는 **IPS·NDR**의 목적과 한계를 살펴보고, WAF가 있는 상황에서 IPS·NDR이 과연 **필수**인지, 또는 **불필요**한지에 대한 시각을 정리합니다.

![IPS와 NDR의 차이](https://blog.plura.io/cdn/column/ips_vs_ndr.jpg)

<!--more-->

---

## 1. **IPS와 NDR: 어떤 역할인가?**

### 💡 기본 정의
- **IPS**:  
  - 주로 **네트워크 경계**에 배치되어, **실시간**으로 **악성 트래픽**을 차단하는 장비  
  - 주로 **알려진 공격 패턴**이나 **규칙**(룰셋)에 따라 동작  
- **NDR**:  
  - **네트워크 내부** 트래픽을 감시·분석하며, **머신러닝·AI** 기반으로 **이상 행위**를 감지  
  - 기존 시그니처 기반 탐지의 한계를 보완해 **알려지지 않은**(new) 위협을 찾고자 함

### 🔑 웹방화벽(WAF)와 비교
- **WAF**는 **HTTP/HTTPS 트래픽**에 특화된 솔루션입니다. **웹 애플리케이션** 공격(XSS, SQL 인젝션, 파일 업로드 취약점 등)에 집중하여, **애플리케이션 계층**을 보호합니다.  
- 반면, **IPS·NDR**는 **HTTP(S) 이외의 다양한 프로토콜**(SMTP, FTP, SSH, RDP, DB 연결 등)까지 포괄하고자 하지만, 대부분이 **암호화**되어 있는 현대 환경에서는 **본문(페이로드) 분석이 제한**됩니다.

---

## 2. **암호화된 패킷 분석의 현실적인 한계**

### 🔒 분석 불가능 구간
- **HTTPS**든 **SSH**든, 패킷이 **암호화**되어 있으면 **IPS·NDR**가 패킷 내용을 직접 보긴 어렵습니다.
- WAF 또한 HTTPS를 복호화(SSL Offloading 등)해서 **웹 요청**을 자세히 들여다볼 수 있지만, 그 외 **SSH, RDP, VPN** 등은 범위 밖입니다.

### ⚠️ SSL 해제(Decryption)의 부담
- IPS·NDR이 제대로 동작하려면, 암호화 트래픽을 중간에서 **복호화**해야 하지만,
  - **개인정보 이슈**, **성능 저하**, **비용**, **인증서 관리** 등 여러 문제가 발생합니다.
- 고위험 웹 구간이라면 몰라도, **SSH·RDP** 등 “원천적으로 암호화된 프로토콜”에서는 **복호화 장비**를 굴려도 실익이 적거나 구현이 번거롭습니다.

---

## 3. **그렇다면 ‘이미 WAF가 있는데, IPS·NDR이 꼭 필요할까?’**

1. **WAF는 웹 계층**(HTTP/HTTPS)에 대해서는 **상당히 강력**한 보안 수단입니다.  
   - SQL 인젝션, XSS, 업로드 취약점 등을 **구체적인 HTTP 요청**에서 찾아내기 때문에 **애플리케이션 보안** 관점에서는 매우 효과적입니다.

2. **IPS·NDR이 다루려는 ‘다른 프로토콜’**(SSH, RDP, DB 연결 등)은 대부분 암호화되어 있어,  
   - **본문 분석**이 불가능하고,  
   - 이벤트 발생 시 제대로 된 **차단/대응**이 힘들 수 있습니다.

3. **결과적으로**,  
   - WAF로 이미 웹 보안을 확보했다면,  
   - **IPS·NDR**가 **같은 HTTPS**를 재복호화해 보는 것은 **중복 투자**이며, SSH나 RDP 같은 다른 프로토콜도 **암호화** 때문에 **어떠한 효과**를 기대하기 어렵습니다.

> “차라리 호스트(서버) 내부에서 보안을 수행하는 **HIPS/EDR**가 더 낫다”  
> → **암호화가 해제된 지점**(실제 프로세스, 파일 시스템, 메모리 접근)을 정확히 감시하고 **차단**할 수 있음

---

## 4. **호스트 기반 보안의 필요성**

### 🛡️ 호스트 기반이 더 유리한 이유
1. **암호화 트래픽 내부 내용**  
   - 호스트(서버) 내부에서는 결국 **복호화된 상태**로 데이터가 처리됩니다.  
   - **HIPS/EDR**는 이 지점을 감시하기 때문에, IPS·NDR의 **암호화 분석 한계**를 보완합니다.

2. **네트워크 성능 저하 없이**  
   - 네트워크 장비에서 SSL 해제를 하지 않아도 되므로, **성능 부담**과 **개인정보 문제**를 크게 줄일 수 있습니다.

3. **종합적인 행위 분석**  
   - 프로세스, 파일 I/O, 메모리 접근, 레지스트리 변조 등 “OS 레벨”에서의 행위를 보고, **실질적인 공격**을 차단할 수 있습니다.

---

## 5. **결론: IPS·NDR은 ‘있어야 하나, 말아야 하나?’**

1. **WAF를 이미 도입**했다면,  
   - 웹 기반 공격(HTTP/HTTPS)은 **WAF**에서 꽤 잘 방어할 수 있습니다.  
   - 암호화된 다른 트래픽(SSH, RDP 등)을 **IPS·NDR**가 분석하려 해도, **실제 내용**은 보이지 않으므로 **차단 효과가 미미**하거나, **오탐/과탐**이 잦을 수 있습니다.

2. **보안 투자를 한정적으로** 해야 한다면,  
   - “**IPS·NDR로 SSL 복호화**”하는 대신, **호스트 내부**(서버, PC)에 **HIPS/EDR**를 적용하는 편이 **실질적 보안 효과**가 크다는 견해가 많습니다.  
   - 네트워크 차원에서 다 잡지 못하는 공격도, 호스트 내부에서 **복호화된 상태**로 확인하고 차단할 수 있기 때문입니다.

3. **‘굳이 IPS·NDR’**?  
   - 일부 고급 **NDR** 솔루션은 행위 분석과 **AI 탐지**로 **차별화**를 시도하지만, 암호화된 환경에서 **기본적인 한계**는 여전히 존재합니다.  
   - 따라서 **“WAF + 호스트 기반 보안”** 조합만으로도 실제 방어력이 충분할 수 있으며, IPS·NDR를 추가로 도입하는 것은 “스티어링 휠 커버”처럼 **취향**이나 **일부 특수 목적**에 가깝다는 의견도 있습니다.

---

## ✅ 최종 정리
1. **WAF**는 웹 트래픽 방어에 특화되어, **HTTP/HTTPS** 공격(애플리케이션 레벨)을 효과적으로 차단합니다.  
2. **IPS·NDR**는 웹 이외의 프로토콜도 다루려 하지만, **암호화** 때문에 본문 분석이 어려워 **제한적 효과**에 그칠 때가 많습니다.  
3. 예산과 운영 리소스가 한정된 상황에서, **호스트 기반 보안**(EDR, HIPS)이 더 실질적인 방어를 제공할 수 있습니다.  
4. 따라서, “**이미 WAF가 있다면, IPS·NDR이 굳이 필요할까?**”라는 의문에는,  
   - **암호화된 환경**에서 IPS·NDR이 할 수 있는 일이 크게 줄어드는 만큼,  
   - **WAF + 호스트 보안** 체계를 먼저 고려하는 것이 **더 합리적**일 수 있다는 결론에 도달할 수 있습니다.

> **결과적으로**, IPS·NDR이 **무조건 필수**라고 보기 어렵습니다.  
> 이미 **WAF**가 웹 영역의 공격을 막아주고, **호스트 보안**으로 내부 행위를 감시·차단한다면, **IPS·NDR**를 추가로 운영하는 것은 실제 보안 강화보다 **중복 투자**나 **과잉 구성**에 가까울 가능성이 있습니다.

---

### 📖 IDS/IPS/NDR 한계 이해하기
* [IDS/IPS, 정말 코어 보안일까?](https://blog.plura.io/ko/tech/why_supplementary_security_services-ips/)
* [NDR의 한계: 해결 불가능한 미션](https://blog.plura.io/ko/column/limitations_of_ndr/)
* [중소·중견 기업 심지어 대기업에서도 NIPS/NDR, 정말로 필요할까?](https://blog.plura.io/ko/column/ips_ndr_needed/)
* [WAF vs IPS vs UTM: 웹 공격 최적의 방어 솔루션 선택하기](https://blog.plura.io/ko/column/waf_ips_utm_comparison/)
* [IPS의 진화와 보안 환경의 변화](https://blog.plura.io/ko/column/ips_classification/)
* [침입차단시스템(IPS) 이해하기](https://blog.plura.io/ko/column/ips_understanding/)
