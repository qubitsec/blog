---
title: "SKT 해킹으로 본 NDR 기술 한계: BPFDoor 같은 스텔스 공격 대응법"
date: 2025-05-02
draft: false
description: "SKT 유심 해킹 사건에 사용된 BPFDoor 사례를 통해 NDR 기술의 한계를 분석하고, 스텔스 공격을 효과적으로 대응할 수 있는 현실적 방안을 정리했습니다"
featured_image: "cdn/column/limitations-ndr-bpfdoor.png"
tags: ["SKT 해킹", "BPFDoor", "NDR 한계", "스텔스 공격", "네트워크 보안", "IDS", "IPS", "Symbiote", "LummaC2", "PLURA-XDR"]
---

📡 **NDR**(Network Detection and Response)은 네트워크 트래픽 분석을 통해 위협을 탐지하려는 기술입니다.
그러나 최근 SK텔레콤 유심 해킹 사건에서 확인된 **BPFDoor**와 같은 고도화된 **스텔스형 공격** 앞에서는 분명한 기술적 한계를 드러냈습니다.

본 문서는 다음 기사에 대응하고자 작성되었습니다:

* [이데일리 - 기존 보안으론 못 막아… 잇단 대형 해킹에 스텔스 위협 대응 촉구](https://n.news.naver.com/article/018/0006002991)

이 글에서는 스텔스형 공격이 왜 기존의 NDR 방식으로는 탐지하기 어려운지 분석하고, 효과적인 현실적 대응 방안으로서 PLURA-XDR 기반의 통합 보안 전략을 제안합니다.

<!--more-->

![NDR 한계](https://blog.plura.io/cdn/column/limitations-ndr-bpfdoor.png)

---

## 1. 최근 스텔스형 공격의 특징 

* **BPFdoor** – 매직 패킷을 받기 전까지 ‘포트리스(portless)’ 상태로 은폐  
* **Symbiote** – 리눅스 정상 프로세스에 기생하는 루트킷, 로그 및 `/proc` 조작 가능  
* **LummaC2** – 난수형 주기·TLS 암호화 C2 통신으로 탐지면 극소화  

이들은 모두 **전통적 시그니처·패턴 기반 보안**을 손쉽게 우회하도록 설계됐습니다.

---

## 2. NDR 기술의 명확한 한계 (요약)

| 구분 | 한계점 | 핵심 이유 |
|------|--------|-----------|
| **① 패킷 부재로 인한 가시성 제로(0)** | 포트리스(portless)·매직 패킷 구조 → **관찰할 트래픽 자체가 없음** | NDR·IDS가 전제하는 ‘보이는 패턴’이 애초에 존재하지 않음 |
| **② 행위 기반 통계 의존 한계** | 흐름 길이·세션 주기 등 **미세 통계치**에 의존 | 정상 세션까지 위협으로 오인(오탐) ↔ 패턴 부재 상황에선 미탐 → 경보 피로(alert fatigue) 가중 |
| **③ 시그널 제거·왜곡형 공격** | BPFdoor·Symbiote·LummaC2 등 **행위 시그널 자체를 없애거나 변조** | NDR이 탐지해야 할 입력값이 사라져 **탐지 논리 자체가 무력화** |

---

## 3. NDR 기술의 명확한 한계 (상세)  

### 🔍 1) ‘패킷 부재’로 인한 탐지 불가능
* **포트리스(portless)** 설계 – 서비스 포트가 단 하나도 열려 있지 않아 NDR·IDS·IPS가 관찰할 **표본 패킷 자체가 없음**  
* 커널 영역 eBPF 훅으로 트래픽을 스니핑한 뒤 사용자 공간을 우회, 흔적 최소화  
* 작동 조건은 공격자가 보내는 **매직 패킷** 단 한 번 → 평상시에는 정상 트래픽과 완전히 동일한 네트워크 침묵 상태  

> NDR은 “패턴이 존재해야 탐지한다”는 가정 아래 동작하지만 **BPFdoor**는 **패턴을 의도적으로 만들지 않는** 방식으로 전제를 깨뜨립니다. 결과적으로 ‘보이는 트래픽’이 전무하므로 통계적 특징을 추출할 여지가 없습니다.

---

### 🔍 2) 네트워크 행위 기반 탐지의 오·미탐 한계
* 흐름 길이·세션 주기 등 **미세 통계치**에 의존하면 정상 세션까지 위협으로 오인 → **오탐**  
* 반대로 **패턴 부재**(BPFdoor) 상황에서는 모델 입력이 없어 **미탐** 발생  
* 경보 피로(alert fatigue)가 누적돼 SOC 대응 속도·정확도 모두 하락

> 네트워크 행위 기반 탐지는 본질적으로 오탐(false positives)과 미탐(false negatives)의 위험을 크게 안고 있습니다. 특히 정상적인 업무 트래픽과 미세한 차이만을 보이는 고도화된 위협인 경우, 잘못된 경고가 지나치게 많이 발생하거나 실제 위협이 탐지되지 않을 수 있습니다. 이는 NDR 시스템이 과부하되거나 관리자의 자원을 낭비하게 만들어 오히려 보안 운영의 효율성을 저하시킬 수 있습니다. 이렇게 누적된 경보는 SOC 팀의 ‘경보 피로(alert fatigue)’를 유발해 대응 속도를 떨어뜨립니다.

---

### 🔍 3) 탐지 우회형 공격 대응 불가능
* **BPFdoor** — 매직 패킷 전까지 포트 오픈·DNS 쿼리 **ZERO**  
* **Symbiote** — 호스트 내부 `/proc`·로그 변조로 패킷 기록 자체를 숨김  
* **LummaC2** — 난수형 주기 + TLS 암호화 비콘으로 시간·패턴 시그널 제거  

> 이들 스텔스 백도어/루트킷은 **NDR이 의존하는 모든 ‘행위 시그널’을 제거하거나 왜곡**합니다. 결국 아무리 고도화된 NDR이라도 “존재하지 않는 세션”을 탐지해야 하는 **논리적 모순**에 직면합니다.

---

## 4. 한계를 극복하는 현실적 대안: **PLURA-XDR**

스텔스형 위협은 사고당 평균 **USD 4.88 M**의 손실을 일으킨다는 2024 IBM 보고서가 증명하듯, “보이지 않는 위험”은 곧 **재무 리스크**입니다. 특히 **BPFdoor**처럼 포트리스·매직 패킷 구조로 **네트워크에 ‘표본 패킷’을 남기지 않는** 공격은 전통 NDR·IDS·IPS를 논리적으로 무력화합니다. 실제로 2024년 A은행 사례에서 BPFdoor는 세 대의 NDR·IDS·IPS 장비를 모두 피해 간 뒤 **6개월간 잠복**했습니다.  

여기에 TLS 1.3·QUIC 확산으로 **패킷 내용까지 암호화**되는 추세가 겹치면서, ‘보이는 패턴’ 기반 탐지 방식은 사실상 '가시성 0%'에 수렴합니다.  

**PLURA-XDR**는 이 ‘관측 불가능 지대’를 엔드포인트·애플리케이션·로그 계층으로 확장된 **다층 가시성**과 GPT 기반 상관 분석으로 메웁니다. 동일 IBM 보고서에 따르면 보안 AI·자동화를 도입한 조직은 침해 비용을 평균 **USD 2.22 M** 절감했습니다. PLURA-XDR은 기술을 넘어 **재무 안전판**으로 작동한다는 의미입니다. 회원 가입 후 1분 내에 확인할 수 있습니다.

### ✅ PLURA-XDR의 통합 접근
1. **본문 로그 실시간 수집** – TLS 내부 요청·응답까지 가시화  
2. **EDR·루트킷 탐지** – 커널/유저 공간 은폐 행위 식별  
3. **상관 분석 & 자동 대응** – 네트워크·호스트·로그를 한 그래프로 묶어 즉시 차단  
4. **제로데이 공격 대응** - 알려지 않는 공격까지 자동으로 탐지  

> **요약:** PLURA-XDR은 NDR이 놓치는 암호화·스텔스 구간을 **엔드포인트·로그·상관 분석**으로 메우는 다층 방어 플랫폼입니다.

---

## 5. 결론: 통합 방어 전략이 답이다

스텔스형 위협 시대, **NDR**으로는 결코 완벽 대응이 불가능합니다.  
**PLURA-XDR**과 같은 **다층·통합 솔루션**을 적용해야만 실질적인 보안 효과를 얻을 수 있습니다.

**✅ PLURA-XDR은 NDR의 한계를 보완하는 현실적 차세대 보안 솔루션.**

---

### 📖 함께 읽기
* [중소·중견 기업 심지어 대기업에서도 NIPS/NDR, 정말로 필요할까?](https://blog.plura.io/ko/column/ips_ndr_needed/)  
* [WAF vs IPS vs UTM 비교하여 웹 공격 최상의 제품 선택하기](https://blog.plura.io/ko/column/waf_ips_utm_comparison/)  
* [NDR의 한계: 해결 불가능한 미션](https://blog.plura.io/ko/column/limitations_of_ndr/)  

* [SKT 해킹 악성코드 BPFDoor 분석 및 PLURA-XDR 대응 전략 (탐지 시연 영상 포함)](https://blog.plura.io/ko/respond/bpfdoor/)  
* [SKT 해킹으로 본 NDR 기술 한계: BPFDoor 같은 스텔스 공격 대응법](https://blog.plura.io/ko/column/limitations-ndr-bpfdoor/)  

---

### 📑 참고 자료
* [IBM Cost of a Data Breach Report 2024](https://www.ibm.com/reports/data-breach)  
* [A Peek Behind the BPFDoor — Elastic Security Labs](https://www.elastic.co/security-labs/a-peek-behind-the-bpfdoor)  
* [Symbiote: A New, Nearly-Impossible-to-Detect Linux Threat — BlackBerry & Intezer](https://blogs.blackberry.com/en/2022/06/symbiote-a-new-nearly-impossible-to-detect-linux-threat)  
* [LummaC2 Revisited: What Makes This Stealer Stealthier and More Lethal — SpyCloud](https://spycloud.com/blog/lummac2-malware-stealthier-capabilities/)  
