---
title: "침입차단시스템(IPS) 이해하기"
date: 2024-02-23T00:00:02
draft: false
description: "침입차단시스템(IPS)을 OSI 모델 기반으로 분석하고, 네트워크 및 호스트 보안의 포괄적 전략으로 이해합니다."
featured_image: "cdn/column/ips_understanding-1.png"
tags: ["IDS", "IPS", "NDR", "OSI 모델", "보안"]
---

🛡️**침입차단시스템**(IPS, Intrusion Prevention System)은 네트워크와 호스트에서 발생하는 **보안 위협을 사전에 찾아내고 차단**하는 핵심 기술입니다.
하지만 오늘날처럼 보안 위협이 **다양하고 교묘**해진 상황에서, IPS를 **단일 솔루션**으로만 바라보는 접근은 한계가 있습니다.

**여러 보안 솔루션**을 겹겹이 도입하는 이른바 **다중∙계층 보안 모델**은 **호환성 문제**, **중복 경보에 따른 피로도**, **예산 및 인력 분산** 등의 심각한 이슈를 유발할 수 있기 때문입니다.
따라서 **OSI 모델** 전 계층을 고려하더라도, **각기 다른 보안 장비**를 무작정 늘리는 대신, **네트워크와 호스트**를 **통합적으로** 보호하는 **단일∙통합 보안 플랫폼**을 도입하는 것이 훨씬 더 효율적이며 효과적인 대안입니다.

<!--more-->

![IPS 이해](https://blog.plura.io/cdn/column/ips_understanding-1.png)

---

## 1. IPS와 OSI 모델 기반 보안 대응
네트워크 통신은 대개 **OSI 모델**의 7계층 구조로 분석할 수 있습니다.  
**IPS**는 이 계층들을 서로 다른 방식으로 보호하며, 계층마다 필요한 접근 방법도 달라집니다.

### Layer 3: 네트워크 계층
- **IP 주소 기반 필터링**:  
  공격자가 IP를 위조(스푸핑)하거나, 비정상적인 라우팅을 유도하려 할 때 이를 식별해 차단할 수 있습니다.
- **라우팅 규칙**:  
  필요하지 않은 네트워크 간 트래픽을 미리 차단하여, 내부 자원으로의 접근 가능성을 줄이고 전반적인 공격 표면을 축소합니다.

### Layer 4: 전송 계층
- **포트 번호 기반 필터링**:  
  포트 스캐닝(서버에서 열려있는 포트를 찾는 시도)이나 SYN 플러드(특정 포트를 반복 공격) 같은 DoS 공격을 막아냅니다.
- **세션 관리**:  
  TCP/UDP 연결 상태를 추적해, 너무 많은 연결이 동시에 시도되거나 비정상적 패턴이 보일 경우 빠르게 감지해 차단합니다.

### Layer 7: 응용 계층
- **HTTP 트래픽 분석**:  
  웹 요청에 숨어 있는 **SQL 인젝션**, **XSS**, **웹 쉘 업로드** 같은 공격을 사전에 걸러낼 수 있습니다.
- **암호화된 트래픽**:  
  HTTPS, TLS 등으로 암호화된 트래픽을 네트워크 단계에서 모두 파악하기는 어렵습니다.  
  따라서 **호스트 기반 보안**(예: HIPS)을 통해 복호화 이후의 행동을 분석하는 것이 매우 중요합니다.

---

## 2. 네트워크 기반 보안 솔루션: 방화벽과 WAF
**네트워크 계층**에서 사용되는 대표적인 보안 솔루션으로, 방화벽(Firewall)과 웹방화벽(WAF)을 들 수 있습니다.

### 네트워크 계층 & 전송 계층: 방화벽(Firewall)
1. **IP와 포트 필터링**  
   불필요한 트래픽을 사전에 걸러내어, 중요한 서버나 내부 자원에 대한 불법 접근을 원천 봉쇄합니다.  
   이는 가장 기본적인 보안 경계를 형성하는 역할을 합니다.

2. **상태 기반 검사 (Stateful Inspection)**  
   단순히 패킷 하나하나를 보는 스테이트리스(stateless) 필터링과 달리, **전체 연결 상태**(세션)를 추적합니다. 예컨대 TCP의 3-way handshake 과정을 정상적으로 밟는지 확인하거나, 비정상적인 연결 시도를 탐지할 수 있습니다.  
   다만, **암호화된 패킷**의 내부 내용은 여전히 볼 수 없기 때문에, 공격자가 **정상적인 연결**처럼 보이게 위장할 경우 일부 한계를 드러냅니다.  
   그럼에도 세션 정보나 통계적인 관찰(접속 횟수, 연결 지속시간 등)을 통해 **의심스러운 트래픽**을 선별적으로 차단하는 데는 유효합니다.  

### 응용 계층: 웹방화벽(WAF)
- **웹 요청 검사**  
  웹 애플리케이션에 특화된 보안 솔루션으로, HTTP(S) 요청에 담긴 **악성 패턴**(예: SQL 인젝션 코드 등)을 분석해 공격을 사전에 차단합니다.  
- **맞춤형 정책**  
  각 웹 애플리케이션의 특성에 따라 세밀하게 필터링 규칙을 조정할 수 있으므로, 기존 방화벽보다 **응용 계층 보안**에 유리합니다.  
  다만, 암호화된 트래픽을 분석하기 위해서는 **SSL 복호화** 등 추가 설정이 필요합니다.

---

## 3. 호스트 기반 보안 솔루션의 중요성
네트워크 기반 솔루션만으로는, **암호화 트래픽**을 완전하게 들여다보기 어렵습니다.  
이러한 맹점을 보완하기 위해, 서버나 PC(호스트) 내부에서 직접 동작하는 **호스트 기반 보안 솔루션**(HIPS 등)이 필수적입니다.

### 암호화된 트래픽과 호스트 내부
- **복호화 지점**:  
  TLS/HTTPS로 암호화된 데이터는 결국 각 서버(호스트) 내부에서 복호화되어 처리됩니다.  
  이 지점에서 호스트 기반 솔루션이 활동하면, **실제 애플리케이션이 동작하는 과정을 면밀히 모니터링**할 수 있습니다.
- **실시간 행위 분석**:  
  파일 시스템 접근, 메모리 변조, 프로세스 간 통신 등 **종합적인 관점**에서 악의적인 동작을 차단할 수 있습니다.

### 호스트 기반 솔루션 예시
1. **안티바이러스/안티멀웨어**  
   파일에 잠복해 있는 바이러스나 랜섬웨어를 탐지·삭제해, 시스템이 감염되는 것을 방지합니다.  
2. **엔드포인트 감지 및 대응(EDR)**  
   보다 정교한 방식으로, 호스트 수준에서 발생하는 **이상 행위**를 실시간 추적하며, 공격 징후가 발견될 시 자동 방어 또는 관리자 알림을 수행합니다.  
3. **데이터 손실 방지(DLP)**  
   내부 중요 문서나 개인 정보가 암호화되어 외부로 유출되지 않도록 모니터링·차단합니다.  
4. **애플리케이션 화이트리스팅**  
   승인된 소프트웨어만 실행하도록 설정하여, 무분별한 프로그램 실행으로 인한 보안 취약점을 줄입니다.  
5. **보안 정보 및 이벤트 관리(SIEM)**  
   호스트와 네트워크 로그를 통합 분석해, 전사적인 보안 사고를 효율적으로 파악하고 대응할 수 있도록 해줍니다.

---

## 4. IPS의 포괄적 정의
위 내용에서 알 수 있듯, **IPS**는 단순히 “네트워크 침입을 막는 하나의 장비나 프로그램”이 아니라,  
- **네트워크 레벨**: 방화벽·WAF·라우팅 규칙 등  
- **호스트 레벨**: HIPS, EDR, DLP, SIEM 등  

이 **모두가 협력**하여 침입을 **다층적으로 차단**하는 **통합 보안 체계**입니다.  
오늘날처럼 암호화 통신이 보편화되고, 클라우드 환경이 확산되면서 **호스트 기반 보안**이 더더욱 부각되고 있습니다.

> ✍️ **침입차단시스템(IPS)은 단일 제품이 아닌, 네트워크와 호스트 보안을 아우르는 총체적 보안 전략이자 시스템을 의미합니다.**

---

## 참고 사항 및 주의
1. **암호화 트래픽 한계**  
   방화벽이나 WAF가 **SSL 복호화 프록시**를 도입해 암호화된 패킷을 해석할 수 있지만, 이는 **추가적인 서버 자원**과 **개인정보 이슈** 등을 야기할 수 있습니다.  
   그래서 더욱 **HIPS, EDR** 같은 호스트 기반 보안 솔루션의 필요성이 강조됩니다.

2. **환경별 보안 요구사항**  
   실제 기업 환경마다 **트래픽 특성**, **네트워크 구조**, **데이터 중요도** 등이 달라, 그에 맞는 IPS 아키텍처를 설계·구축해야 합니다.

3. **지속적인 업데이트와 모니터링**  
   공격 기법은 빠르게 진화하고 있으므로, 보안 장비와 호스트 기반 솔루션 모두 **지속적인 보안 패치 및 정책 업데이트**가 중요합니다.

> **💡 결론**: OSI 모델 전 계층을 고려하면서, **네트워크 기반**과 **호스트 기반** 보안을 함께 도입하는 것이 최신 환경에서의 IPS 전략 핵심입니다.  
> 암호화가 진화하더라도, **상태 기반 검사**, **행위 분석**, **로그 통합 관리** 등을 통해 다각도로 위협을 파악하고 막아내야 합니다.

---

### 📖 IDS/IPS/NDR 한계 이해하기
* [IDS/IPS, 정말 코어 보안일까?](https://blog.plura.io/ko/tech/why_supplementary_security_services-ips/)
* [NDR의 한계: 해결 불가능한 미션](https://blog.plura.io/ko/column/limitations_of_ndr/)
* [중소·중견 기업 심지어 대기업에서도 NIPS/NDR, 정말로 필요할까?](https://blog.plura.io/ko/column/ips_ndr_needed/)
* [IPS와 NDR 차이와 한계](https://blog.plura.io/ko/column/ips_vs_ndr/)
* [WAF vs IPS vs UTM: 웹 공격 최적의 방어 솔루션 선택하기](https://blog.plura.io/ko/column/waf_ips_utm_comparison/)
* [IPS의 진화와 보안 환경의 변화](https://blog.plura.io/ko/column/ips_classification/)
